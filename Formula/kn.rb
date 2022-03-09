class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.3.0",
      revision: "736301231eb7b60badb67a5d17da51ddb0ce97ff"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f7a0f00b60c1a09ba1354b4818e80afd5bfdc295008afd1edb588ae8b0d9ee5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f7a0f00b60c1a09ba1354b4818e80afd5bfdc295008afd1edb588ae8b0d9ee5"
    sha256 cellar: :any_skip_relocation, monterey:       "a815b3147d0617d6b5177e3c390fd41af8f5c82bfd2fed7c05474158915d64f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "a815b3147d0617d6b5177e3c390fd41af8f5c82bfd2fed7c05474158915d64f5"
    sha256 cellar: :any_skip_relocation, catalina:       "a815b3147d0617d6b5177e3c390fd41af8f5c82bfd2fed7c05474158915d64f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c6a3b5e72a6d2dcf19990f7fe9548847e52099280d7556b48cafaeef52b503d"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -X knative.dev/client/pkg/kn/commands/version.Version=v#{version}
      -X knative.dev/client/pkg/kn/commands/version.GitRevision=#{Utils.git_head(length: 8)}
      -X knative.dev/client/pkg/kn/commands/version.BuildDate=#{time.iso8601}
    ]

    system "go", "build", "-mod=vendor", *std_go_args(ldflags: ldflags), "./cmd/..."
  end

  test do
    system "#{bin}/kn", "service", "create", "foo",
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
