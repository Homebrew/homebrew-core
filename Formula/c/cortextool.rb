class Cortextool < Formula
  desc "CLI tool to interact with Cortex and manage configurations"
  homepage "https://github.com/cortexproject/cortex-tools"
  url "https://github.com/cortexproject/cortex-tools/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "551ca40e29e008b0364c9ae7000c3f0417e0176a0c32412a3e98cb95d07f4342"
  license "Apache-2.0"
  head "https://github.com/cortexproject/cortex-tools.git", branch: "main"

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    ldflags = "-X github.com/cortexproject/cortex-tools/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/cortextool"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cortextool version")

    # `rules lint` reformats rule files in place: it reorders keys, reindents,
    # and rewrites PromQL expressions onto a single line.
    (testpath/"rules.yml").write <<~YAML
      namespace: test
      groups:
        - name: example
          rules:
            - record: job:up:sum
              expr: |
                sum(
                  up
                )
    YAML
    assert_match "SUCCESS: 1 rules found, 1 linted expressions",
                 shell_output("#{bin}/cortextool rules lint rules.yml 2>&1")
    assert_match "expr: sum(up)", (testpath/"rules.yml").read

    (testpath/"invalid.yml").write <<~YAML
      namespace: test
      groups:
        - name: example
          rules:
            - record: job:up:sum
              expr: sum(up
    YAML
    output = shell_output("#{bin}/cortextool rules lint invalid.yml 2>&1", 1)
    assert_match "unclosed left parenthesis", output
  end
end
