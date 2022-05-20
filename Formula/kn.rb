class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.4.1",
      revision: "c53658bd0ee61dc0c87e2cda589f1bc79ec84983"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5079eb41c1fe910fae52c955e8b32d0479119e4b596f5795a00b1f5a4f539451"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5079eb41c1fe910fae52c955e8b32d0479119e4b596f5795a00b1f5a4f539451"
    sha256 cellar: :any_skip_relocation, monterey:       "5693752cf475cff80fc71cde8002e6350c2c2ad060430569774d2975348eda4a"
    sha256 cellar: :any_skip_relocation, big_sur:        "5693752cf475cff80fc71cde8002e6350c2c2ad060430569774d2975348eda4a"
    sha256 cellar: :any_skip_relocation, catalina:       "5693752cf475cff80fc71cde8002e6350c2c2ad060430569774d2975348eda4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0229c56bf8f68cae3185965bf5d7bcde59090778b19c49538774724ebf96625b"
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
