class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.11.1",
      revision: "0680c81b43c2caae6ca5edd21213dfde4b77efd9"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd8b0e70cfc29ee135e342429823b9b50ba8e9aa4fffcf07c1d05edc0f9e2f93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd8b0e70cfc29ee135e342429823b9b50ba8e9aa4fffcf07c1d05edc0f9e2f93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd8b0e70cfc29ee135e342429823b9b50ba8e9aa4fffcf07c1d05edc0f9e2f93"
    sha256 cellar: :any_skip_relocation, sonoma:         "32e95b23c3b2cbe119a8ce49a2e84be922b960d9e9a72fb51ec7f3d8ca8830c1"
    sha256 cellar: :any_skip_relocation, ventura:        "32e95b23c3b2cbe119a8ce49a2e84be922b960d9e9a72fb51ec7f3d8ca8830c1"
    sha256 cellar: :any_skip_relocation, monterey:       "32e95b23c3b2cbe119a8ce49a2e84be922b960d9e9a72fb51ec7f3d8ca8830c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8794c5d7071a0f3a44e6009251f6e995dd28f9e3be1789a97a431f0dac58bfc"
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
