class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "v0.27.0",
      revision: "a1cf5bf81f77b9602607735af286fb3cefb3fee2"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec177ff2ce1896e01a1c1738b4b3878c59256684ac2197ee577ff4ef8cfc6bd1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec177ff2ce1896e01a1c1738b4b3878c59256684ac2197ee577ff4ef8cfc6bd1"
    sha256 cellar: :any_skip_relocation, monterey:       "1a6d04c55b1a6d412f79af7950adca99ca6dd0307b322ae9ecec435ad6c14a26"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a6d04c55b1a6d412f79af7950adca99ca6dd0307b322ae9ecec435ad6c14a26"
    sha256 cellar: :any_skip_relocation, catalina:       "1a6d04c55b1a6d412f79af7950adca99ca6dd0307b322ae9ecec435ad6c14a26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "985b9e76ffc877ecc940b57a791cb84c830ac9427caa6cabab1874ecb0caa64a"
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
