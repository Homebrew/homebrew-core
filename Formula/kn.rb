class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.3.0",
      revision: "736301231eb7b60badb67a5d17da51ddb0ce97ff"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b8143eec4ebac5055ab52bc88646e088ffb49e3ad406eeac8994521807e3c1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b8143eec4ebac5055ab52bc88646e088ffb49e3ad406eeac8994521807e3c1c"
    sha256 cellar: :any_skip_relocation, monterey:       "cd57a939d6ade2a3d5142e7e73be56e4c36339731112408a2b8847e21da78f5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd57a939d6ade2a3d5142e7e73be56e4c36339731112408a2b8847e21da78f5b"
    sha256 cellar: :any_skip_relocation, catalina:       "cd57a939d6ade2a3d5142e7e73be56e4c36339731112408a2b8847e21da78f5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1b9cd24d2e3d916f4660413d5b6710d151329df6528b634a30b1c422f802485"
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
