class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "v0.25.1",
      revision: "99e2c9279d62fff95589ee2c242d11d0deac4289"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "153e6261572b440165f50fdff03a0e261e20ec3128a127ceac71940e95f0aa4e"
    sha256 cellar: :any_skip_relocation, big_sur:       "ff799fabf564de8201bf797b990ec8045f5fb6d2257508910ffffe1ccbd9673a"
    sha256 cellar: :any_skip_relocation, catalina:      "ff799fabf564de8201bf797b990ec8045f5fb6d2257508910ffffe1ccbd9673a"
    sha256 cellar: :any_skip_relocation, mojave:        "ff799fabf564de8201bf797b990ec8045f5fb6d2257508910ffffe1ccbd9673a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5cd97c29b91774f1f83cfa05c11115f2e928dfc5f3738ded35cae3ef941b24c"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -X knative.dev/client/pkg/kn/commands/version.Version=v#{version}
      -X knative.dev/client/pkg/kn/commands/version.GitRevision=#{Utils.git_head(length: 8)}
      -X knative.dev/client/pkg/kn/commands/version.BuildDate=#{time.iso8601}
    ].join(" ")

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
