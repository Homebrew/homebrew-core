class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.24.0",
      revision: "f2bfc7f364743c60fefce78e392e5f547aa5ad71"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0f70cdf577526e93fd4e5496c58e9f5c9410821a97632d70a555f246a85985e7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4efd6d4c334062e1b563a465c1479e90090d3b5be8634cedf530d0a939a2fe09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "785cfed2cb10469a9dd2a274caf6f2d708bcde030a78c4ff9a07cda47e72a62d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "79720ec6d058da2ab7d17a001a684498686f63f9f413322b85fd4e249721b898"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "61da0d0cadcd2e204e1c0c78df4c5c9c27965aa3dfbcde03e9eb4b3c26d6c58c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"

    ldflags = %W[
      -X knative.dev/client/pkg/commands/version.Version=v#{version}
      -X knative.dev/client/pkg/commands/version.GitRevision=#{Utils.git_head(length: 8)}
      -X knative.dev/client/pkg/commands/version.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/kn"

    generate_completions_from_executable(bin/"kn", shell_parameter_format: :cobra)
  end

  test do
    system bin/"kn", "service", "create", "foo",
      "--namespace", "bar",
      "--image", "gcr.io/cloudrun/hello",
      "--target", "."

    yaml = File.read(testpath/"bar/ksvc/foo.yaml")
    assert_match("name: foo", yaml)
    assert_match("namespace: bar", yaml)
    assert_match("image: gcr.io/cloudrun/hello", yaml)

    version_output = shell_output("#{bin}/kn version")
    assert_match("Version:      v#{version}", version_output)
    assert_match("Build Date:   ", version_output)
    assert_match(/Git Revision: [a-f0-9]{8}/, version_output)
  end
end
