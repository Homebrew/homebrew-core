class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.9.1",
      revision: "1ce39bb21b231548631149fe1e19a736ae91cdc3"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29c740a019b368ad7315415abdbef3c702f2a8de097e55bd05434cfd0edab164"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29c740a019b368ad7315415abdbef3c702f2a8de097e55bd05434cfd0edab164"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29c740a019b368ad7315415abdbef3c702f2a8de097e55bd05434cfd0edab164"
    sha256 cellar: :any_skip_relocation, ventura:        "b9a99ee6d6ecfc25b57492a875c10f5f37e5f902cd5e6143930a6fac88ca01a3"
    sha256 cellar: :any_skip_relocation, monterey:       "b9a99ee6d6ecfc25b57492a875c10f5f37e5f902cd5e6143930a6fac88ca01a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9a99ee6d6ecfc25b57492a875c10f5f37e5f902cd5e6143930a6fac88ca01a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0acfaa1271e62e24c0baac8967dc148b1718a31e114726ee16adc5c4685cc589"
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
