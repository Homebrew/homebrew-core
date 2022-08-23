class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.7.0",
      revision: "6d86bf7557aa0525dd05fe5045492ca176c4a121"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd5f2ce9f0b56b742230ef5fe0ac29911f9fe7d3fd59b4907f47f74dd0a9ceb0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd5f2ce9f0b56b742230ef5fe0ac29911f9fe7d3fd59b4907f47f74dd0a9ceb0"
    sha256 cellar: :any_skip_relocation, monterey:       "b9392056c0405c99971e989dbe10b81b4f3781e190e24c7e389393c9f2680e12"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9392056c0405c99971e989dbe10b81b4f3781e190e24c7e389393c9f2680e12"
    sha256 cellar: :any_skip_relocation, catalina:       "b9392056c0405c99971e989dbe10b81b4f3781e190e24c7e389393c9f2680e12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a216c26f43bd7237a977f5e1c7387db773897f37b9163709680e9afcfabddee5"
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
