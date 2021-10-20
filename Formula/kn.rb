class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "v0.26.0",
      revision: "61b8a754149a1442fd76a32e98e45dbce2d09b78"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "61c1e60bb5a297b50c19b29fc64420bdd2da3c1d9a104a5fd7c0f908d7b9465c"
    sha256 cellar: :any_skip_relocation, big_sur:       "b02d96368c5d026876ecc9168b36b1c494e5b3ff9724853ce470a969f739c5a2"
    sha256 cellar: :any_skip_relocation, catalina:      "b02d96368c5d026876ecc9168b36b1c494e5b3ff9724853ce470a969f739c5a2"
    sha256 cellar: :any_skip_relocation, mojave:        "b02d96368c5d026876ecc9168b36b1c494e5b3ff9724853ce470a969f739c5a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f4b4f870fe3845c801cb10108dbd69cbdf1029e1dbf1c24c3c607df0c9eeba1"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -X knative.dev/client/pkg/kn/commands/version.Version=v#{version}
      -X knative.dev/client/pkg/kn/commands/version.GitRevision=#{Utils.git_head(length: 8)}
      -X knative.dev/client/pkg/kn/commands/version.BuildDate=#{time.iso8601}
    ].join(" ")

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
