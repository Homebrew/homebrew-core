class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.3.1",
      revision: "a591c0c0278e906b9677de6df8188991f21265a4"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f536caa54ff5bf9197f358f18003ad44ea7a730fcd0f197d64c0a714d9f689fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f536caa54ff5bf9197f358f18003ad44ea7a730fcd0f197d64c0a714d9f689fb"
    sha256 cellar: :any_skip_relocation, monterey:       "5ed4e11b2419f941e4aaa3cf5fd8e23b6b36b80d871b6df1e9ccceff43cc38c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ed4e11b2419f941e4aaa3cf5fd8e23b6b36b80d871b6df1e9ccceff43cc38c5"
    sha256 cellar: :any_skip_relocation, catalina:       "5ed4e11b2419f941e4aaa3cf5fd8e23b6b36b80d871b6df1e9ccceff43cc38c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09c1dc5c1de3e67551ad5d462411e4d793f9e78c3159b79d746609f1bab103d1"
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
