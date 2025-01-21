class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.16.1",
      revision: "3bf1ed8eb51e4700d253b654866063bf5421c863"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e5daab383dda02129e1910b59e35fa1d875bd1c9696d0cde360aad3df67003c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef1ef6503a5c46cb5277538371db37ccd22411cc6f6825d8c8a1e8e6651897bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d969b2daea46765127b155d0d38a1c720fa69b7ff16c0365952017b703ef268e"
    sha256 cellar: :any_skip_relocation, sonoma:        "198335fab48da6d5725e163754e6384806f4adeb19a80b92fd2d5d3b747788f6"
    sha256 cellar: :any_skip_relocation, ventura:       "74db90aca044e047de13f0cfad53259256e3d6ac4dd745cb92eb52465daac5cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3c90ce26f86d1b6cda1973848b93446473b07c317c5c407cb5000404fa50143"
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
