class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.20.0",
      revision: "b66b3da6ff01ee9c1f543786b56520194ac4eec1"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca9c7ec25beac3dd0df1af2476827e9550fa4fe3fe3efdceee01978bc126b756"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6afa29700ac55a4bce686bf78a7cee5ee99bbfeb310672e0773158cdde384a04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa3ccb0f95a7dcbce20a796dd32ca65f5b5c9cec9e04554320fdd8c4948f065c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad536768d53272e5416025745a0a49f4965c69ee0c79561fe26c58b12163f1ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99660c440f3aaec918881e208e66945d1b1710601c1dd21c2fed4c218deb8001"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3d52b582b8368ecfd50c7541e4960748066f4dff9e608dfcbcd6c85a7676e7d"
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
