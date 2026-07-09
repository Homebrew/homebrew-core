class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.22.1",
      revision: "67a85d32ee5df847ac57b7ec198f973c93c142da"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "297abe669c986eb66b91db42cf8aee508ad4efe7da3952e5b4d51d2d52844d4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "422625f0d0af4d843a17aa3d4a50773ac05bb3f8fead72240da4857b3bcdd630"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67a49cbbabd436b451406a5f1166ff7e16ebd6391d8c5b65eaffd76c7da8deb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "4623c5241c5d9c665e0bbd32e2f184429e0c4830f901d8645de92304d8508c08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9951a8c864d11c239fd89fd0ff5676b51cd582e06a13da64d1f3758d13a419b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a62e34853aa11ebabaea607b2086d4a1477f383fc57e5026a16cf2602f4b6b52"
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
