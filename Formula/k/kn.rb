class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.20.0",
      revision: "b66b3da6ff01ee9c1f543786b56520194ac4eec1"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75c547d1797deabc509f53ef0799539001d7d88a1b480ae624ad2a02d3c01743"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4400084c2e9671e6ca2c939ce63d500842ae1ae4f6296db64a5e4fce75713fa6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cb0b598781daa39ccd291e8542a5101559a97a23e41e8982e5e9fae712a8b48"
    sha256 cellar: :any_skip_relocation, sonoma:        "b38747396f37345703b20d1d56dda4ccbfe1a9b2c10dfd6ea0ce178225f8430d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21a87adb36e3d3b064ff6422ec4b32c17cafc3e131d67c31411854ec255c7d56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f69e19dafd50fe630aa4453153045b0a955c22c58423e3fb21f891f2460de579"
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

    generate_completions_from_executable(bin/"kn", "completion")
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
