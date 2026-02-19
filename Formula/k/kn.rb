class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.21.0",
      revision: "382000a93f176980bf5ef182d4f8a2682a167e65"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf30b69b4f1c305714768b732015dd7a703bd536e4a0a5021274fc0f17a991a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "438be7588ddfd635912a6130d68de906cf7db3f8c655a5f97b990d892a6ece55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e51cc4c2f46c0eda809247edb27dee4c010994858051362e70721758e8ab5f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ff6f8b240ea7e60bf2b022b6cc9d65ae7ec8506cc190465eafa34ce48312283"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d3c49ba8034b4b91f75e8427d829f9d470506c5cbeacae309a8083f52f3bbb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d74f940af91492cee17f8547b8fe03a0805e1d32858604326bc20bfd932b8bba"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"

    ldflags = %W[
      -s -w
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
