class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.7.1",
      revision: "e2f6caf3b50fddc67dac612d056da7223da77b50"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2830ebe93937c44fbe2b52642abb957d00f4dd959497f1e8cd39dcf76501a96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2830ebe93937c44fbe2b52642abb957d00f4dd959497f1e8cd39dcf76501a96"
    sha256 cellar: :any_skip_relocation, monterey:       "da02432562efb0838778ad030238bf39658e94aaa6abb42b36b987c74e92f934"
    sha256 cellar: :any_skip_relocation, big_sur:        "da02432562efb0838778ad030238bf39658e94aaa6abb42b36b987c74e92f934"
    sha256 cellar: :any_skip_relocation, catalina:       "da02432562efb0838778ad030238bf39658e94aaa6abb42b36b987c74e92f934"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f795177d69c669a4a2844b5f3917ba8983af3599da271fc6c932283964aee32"
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
