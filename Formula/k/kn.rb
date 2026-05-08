class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.22.0",
      revision: "479f2162b627314c75e93b84be81290e3f4bc237"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac3f057f6036fd79548c044946f8366896c949b05cc12d744b7f3a9ea0a38677"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbb2653eeff8b307833f05f809bc53b123907789802554a291267dae8f9bb426"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a3fc043392f32c5ffed0e95759a8e988d1c1c1b31c9d83e613e404a31fc642d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d30d58a02a16e9de407e820db2c0c471f5ed0710d9d482de83ff6bc3655e70ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1db3d8a6e09976f6b7a948410983eaa911f904f4b33ad69928397ed55b4a67c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f611959fa110d983d07fdfc7c03e7b7bb540d4af4b428bc6b034eaf454e5c641"
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
