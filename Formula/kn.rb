class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.2.0",
      revision: "5030b5df2fc54d215beff1e8f2134fe7740dbfc0"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4642e40a8bea8ddcc0d60391bbd440432b4656c51ac8289f54648f4552c7d93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4642e40a8bea8ddcc0d60391bbd440432b4656c51ac8289f54648f4552c7d93"
    sha256 cellar: :any_skip_relocation, monterey:       "5f4e5ca65c391ac79a908226e698c98902d2f50bd5622a7930829f7d3b5f3c2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f4e5ca65c391ac79a908226e698c98902d2f50bd5622a7930829f7d3b5f3c2d"
    sha256 cellar: :any_skip_relocation, catalina:       "5f4e5ca65c391ac79a908226e698c98902d2f50bd5622a7930829f7d3b5f3c2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22ce03a1582477b7668c76b7a3338874174a250bd1981ad46a1a0730a65eed38"
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
