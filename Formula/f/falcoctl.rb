class Falcoctl < Formula
  desc "CLI tool for working with Falco and its ecosystem components"
  homepage "https://github.com/falcosecurity/falcoctl"
  url "https://github.com/falcosecurity/falcoctl/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "aba711ad4b8e3095bba0f647811dcbbabe998218a38dd14cf132799e84537187"
  license "Apache-2.0"
  head "https://github.com/falcosecurity/falcoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6973e6e610d7f46a4ab85813a8617ef0029d490ecfd3abd81e24c218603030ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2ae9ea05ac4174f6fc53ac683c5895d46e508cbd6f5f75b792e85497e7d82c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b0c99086452e19e39ce25043594e0c593921b7e5b2296fe7c77ffe130ea2be4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8fb08dfa1ef441e327221098d361b57cb90b8e31c74b134554579f3d1e0be4e"
    sha256 cellar: :any,                 x86_64_linux:  "7267e7e50d653703ba5fc2f96b96e46a301197ba4e67957be883c5bf87f4e2c0"
  end

  depends_on "go" => :build

  def install
    pkg = "github.com/falcosecurity/falcoctl/cmd/version"
    ldflags = %W[
      -X #{pkg}.buildDate=#{time.iso8601}
      -X #{pkg}.gitCommit=#{tap.user}
      -X #{pkg}.semVersion=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"falcoctl", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"index.yaml").write <<~YAML
      - name: test-artifact
        type: rulesfile
        registry: ghcr.io
        repository: falcosecurity/rules/falco-rules
    YAML

    config = testpath/"falcoctl.yaml"
    system bin/"falcoctl", "index", "add", "myindex", "file://#{testpath}/index.yaml", "--config", config
    assert_match "myindex", shell_output("#{bin}/falcoctl index list --config #{config}")

    assert_match version.to_s, shell_output("#{bin}/falcoctl version")
  end
end
