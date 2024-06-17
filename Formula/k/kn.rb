class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.14.0",
      revision: "6a1449c2e8a8b5fd667cac65164506ad9632ef4d"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "676250ff01a46dcb077144490c254d73f26cb000a4c0ba2877bf137af14ec91c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "676250ff01a46dcb077144490c254d73f26cb000a4c0ba2877bf137af14ec91c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "676250ff01a46dcb077144490c254d73f26cb000a4c0ba2877bf137af14ec91c"
    sha256 cellar: :any_skip_relocation, sonoma:         "a5e7c5ed68d72349507aeda24e2412a241177a2557c2dce855dc933b2de9bb1c"
    sha256 cellar: :any_skip_relocation, ventura:        "a5e7c5ed68d72349507aeda24e2412a241177a2557c2dce855dc933b2de9bb1c"
    sha256 cellar: :any_skip_relocation, monterey:       "a5e7c5ed68d72349507aeda24e2412a241177a2557c2dce855dc933b2de9bb1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f66782ff5a206c86ab4c0e582c3ee87637560aa6131bb030286da86b2ade7ec6"
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
