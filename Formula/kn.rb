class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.8.1",
      revision: "1db36698e19b9015c215b9d12cedd0f196012734"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad8862d98ad48e89ca9b2c3f7cbb8398d0f8fca91a13b8bb9087e9858a76a163"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad8862d98ad48e89ca9b2c3f7cbb8398d0f8fca91a13b8bb9087e9858a76a163"
    sha256 cellar: :any_skip_relocation, monterey:       "82eb434e959abb0ef040063a8a0e429bae89e8fe48dc63aa736b34dce6b5322c"
    sha256 cellar: :any_skip_relocation, big_sur:        "82eb434e959abb0ef040063a8a0e429bae89e8fe48dc63aa736b34dce6b5322c"
    sha256 cellar: :any_skip_relocation, catalina:       "82eb434e959abb0ef040063a8a0e429bae89e8fe48dc63aa736b34dce6b5322c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc00ff70573fa4853fe17a126f13453881459c52af1e27458ad2dd3e04540fe8"
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

    generate_completions_from_executable(bin/"kn", "completion", shells: [:bash, :zsh])
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
