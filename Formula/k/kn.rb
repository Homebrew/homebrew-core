class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.13.0",
      revision: "543522a33edc79e056c09e4f9b78135e4fed5307"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ad9e97b0daa1c78969883c900a533baf6e599702b9bb28dfec4e8a5132be261"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ad9e97b0daa1c78969883c900a533baf6e599702b9bb28dfec4e8a5132be261"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ad9e97b0daa1c78969883c900a533baf6e599702b9bb28dfec4e8a5132be261"
    sha256 cellar: :any_skip_relocation, sonoma:         "c9b4bbcfa3ac481854dfb22229667710509a0243f2a7051bb15df9dbc2832580"
    sha256 cellar: :any_skip_relocation, ventura:        "c9b4bbcfa3ac481854dfb22229667710509a0243f2a7051bb15df9dbc2832580"
    sha256 cellar: :any_skip_relocation, monterey:       "c9b4bbcfa3ac481854dfb22229667710509a0243f2a7051bb15df9dbc2832580"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b44b8ce2c8264a10884cac443b60bae6357ea6a069baaa870023b01c70d65d66"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -X knative.dev/client/pkg/kn/commands/version.Version=v#{version}
      -X knative.dev/client/pkg/kn/commands/version.GitRevision=#{Utils.git_head(length: 8)}
      -X knative.dev/client/pkg/kn/commands/version.BuildDate=#{time.iso8601}
    ]

    system "go", "build", "-mod=vendor", *std_go_args(ldflags:), "./cmd/..."

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
