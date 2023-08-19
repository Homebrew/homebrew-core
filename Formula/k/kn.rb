class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.11.0",
      revision: "b7508e674449db42bfe4d55ce5226d4fc8603f5a"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "546d118d179de625ea3cbb70ac0ae21a2b132b0462733e7246956d106c0f6443"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "546d118d179de625ea3cbb70ac0ae21a2b132b0462733e7246956d106c0f6443"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "546d118d179de625ea3cbb70ac0ae21a2b132b0462733e7246956d106c0f6443"
    sha256 cellar: :any_skip_relocation, ventura:        "031b6652bea16800f4e90026255cf65c648c96f2c251786abecdee027bd7ba28"
    sha256 cellar: :any_skip_relocation, monterey:       "031b6652bea16800f4e90026255cf65c648c96f2c251786abecdee027bd7ba28"
    sha256 cellar: :any_skip_relocation, big_sur:        "031b6652bea16800f4e90026255cf65c648c96f2c251786abecdee027bd7ba28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc995e55aed120a028520db8fedbb5803f33066373d6d4d8f5917e96cfaa24f0"
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
