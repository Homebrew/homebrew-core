class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.7.0",
      revision: "6d86bf7557aa0525dd05fe5045492ca176c4a121"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "126de891572f1b4968d46829d54ef14afa12ebfb07c65c017801949dc0f6e089"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "126de891572f1b4968d46829d54ef14afa12ebfb07c65c017801949dc0f6e089"
    sha256 cellar: :any_skip_relocation, monterey:       "559fe7b81f6e0762557d52677067ca24c99647b160e5bab476bd8ecde0653565"
    sha256 cellar: :any_skip_relocation, big_sur:        "559fe7b81f6e0762557d52677067ca24c99647b160e5bab476bd8ecde0653565"
    sha256 cellar: :any_skip_relocation, catalina:       "559fe7b81f6e0762557d52677067ca24c99647b160e5bab476bd8ecde0653565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "065eecd72d8a616aedeb178a11eeed98a6e23bc30197ba45bba759af003ad68f"
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
