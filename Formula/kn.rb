class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.9.1",
      revision: "1ce39bb21b231548631149fe1e19a736ae91cdc3"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abc5a3ea7c44c8d90f18cdc35f45b25fbe7ab2ba203aff6832a8a38a931ed779"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abc5a3ea7c44c8d90f18cdc35f45b25fbe7ab2ba203aff6832a8a38a931ed779"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abc5a3ea7c44c8d90f18cdc35f45b25fbe7ab2ba203aff6832a8a38a931ed779"
    sha256 cellar: :any_skip_relocation, ventura:        "e03b0af4f654e8414b37a0d10b97a3d29999dd49a1224d3e75a2ed5a4ea3d8db"
    sha256 cellar: :any_skip_relocation, monterey:       "e03b0af4f654e8414b37a0d10b97a3d29999dd49a1224d3e75a2ed5a4ea3d8db"
    sha256 cellar: :any_skip_relocation, big_sur:        "e03b0af4f654e8414b37a0d10b97a3d29999dd49a1224d3e75a2ed5a4ea3d8db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61d9fffaeb65a3e444c487a7283109d7edefe93fb18b071e34fcf59965575ed1"
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
