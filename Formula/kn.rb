class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.4.1",
      revision: "c53658bd0ee61dc0c87e2cda589f1bc79ec84983"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7a562383e84810250a4a731b9688609af83657e6a8f117582175035494e83a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7a562383e84810250a4a731b9688609af83657e6a8f117582175035494e83a5"
    sha256 cellar: :any_skip_relocation, monterey:       "602d779af5d336c0c33bf4c344328933b48c56a28f71390e89c97f3db4ee5959"
    sha256 cellar: :any_skip_relocation, big_sur:        "602d779af5d336c0c33bf4c344328933b48c56a28f71390e89c97f3db4ee5959"
    sha256 cellar: :any_skip_relocation, catalina:       "602d779af5d336c0c33bf4c344328933b48c56a28f71390e89c97f3db4ee5959"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca8150af3e293baadd6136287853e198841ebc8005ed9bf8960db05e82ae99ad"
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
