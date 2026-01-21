class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.50.1.tar.gz"
  sha256 "1357b363142e9e2d624b10f86c69d7a73efde338725d276e92028dcdf54e51a0"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e12b00b8714304d5db10cde628726eb21d56a81f69263173c13f8c2c5d6e8cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4ced3c993418728c547ff4c9e886327448a9b5d88f6b9076ec01d359f19e2aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d2625c9d00af8c96a8209e7ea09827770925b2140797709d7ed6ced96449875"
    sha256 cellar: :any_skip_relocation, sonoma:        "07912edd8ba0b1e9607e3ae28014d57d15dc8f8518b99e9a92227c11910c89d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64fed884be12baa2387d1db20dc77124bfcb4c7266a7fde9251e205dd989fa79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "376df0ea4a0255de26dee6048b5b289ce9f847fb6ba420a3cfd57894efc33bfe"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/relayproxy"
  end

  test do
    port = free_port

    (testpath/"flags.yml").write <<~YAML
      test-flag:
        variations:
          true-var: true
          false-var: false
        defaultRule:
          variation: true-var
    YAML

    (testpath/"test.yml").write <<~YAML
      listen: #{port}
      pollingInterval: 1000
      retriever:
        kind: file
        path: #{testpath}/flags.yml
    YAML

    pid = spawn bin/"go-feature-flag-relay-proxy", "--config", "#{testpath}/test.yml"
    begin
      assert_match "true", shell_output("curl --silent --retry 5 --retry-connrefused http://localhost:#{port}/health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
