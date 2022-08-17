class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.6.1",
      revision: "932b69a9ac9362bbead98f2bb66e021eff9f5707"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7da7dedef8407ed1bdfdc712ef2db97f0cc24cc1382e0e84090fdd7fa53a4af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7da7dedef8407ed1bdfdc712ef2db97f0cc24cc1382e0e84090fdd7fa53a4af"
    sha256 cellar: :any_skip_relocation, monterey:       "f77cb664c4136261f64fc121b04b74a74973916cad69aeb731372d042f7655c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "f77cb664c4136261f64fc121b04b74a74973916cad69aeb731372d042f7655c3"
    sha256 cellar: :any_skip_relocation, catalina:       "f77cb664c4136261f64fc121b04b74a74973916cad69aeb731372d042f7655c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b789ef0e2f4e0fa2c4513b3b56e40b804a9067c05018a75ea026de26c02a984"
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
