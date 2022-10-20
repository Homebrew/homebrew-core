class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.7.1",
      revision: "e2f6caf3b50fddc67dac612d056da7223da77b50"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d2a99fd7e74d94450a50658c6288d7866a11392b21fa353bf73939f0e4daa19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d2a99fd7e74d94450a50658c6288d7866a11392b21fa353bf73939f0e4daa19"
    sha256 cellar: :any_skip_relocation, monterey:       "ae3844d5fdcf405b2974b1bb2c18d37a33e6bd213a43e00b24b6c77fe64e5476"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae3844d5fdcf405b2974b1bb2c18d37a33e6bd213a43e00b24b6c77fe64e5476"
    sha256 cellar: :any_skip_relocation, catalina:       "ae3844d5fdcf405b2974b1bb2c18d37a33e6bd213a43e00b24b6c77fe64e5476"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4554404bff3257c4cf2d7328bdcb4ccb93bd8ebff814ea8fc2521e627523094f"
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
