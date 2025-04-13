class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.17.0",
      revision: "f73472454667de171935724b3e2f2ee219398cf8"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ffb66728a21e1dc3e9aee58d432267c183c12bc027c3cd44010cb5c665433a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48b78184fc6749a804f5eb3598b4d50ef245a5f189c0f2084ec83e0340e8a62d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2615bcdb1ca0e34fecff900504407876053fde0da920a95476d4167110eb94a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6611c463a905ff466ebc2cb86261a45b1054073155d82971c11a8a39c37bf2e9"
    sha256 cellar: :any_skip_relocation, ventura:       "9600bdfa35658bd14da7f756c1528fe02341f3986a11b376eaa8309c8bd78174"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2042cfe7fd4175512ec33de0ab87955ecca687a01ef1b89f9d88b5fbf6f3f6d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bdbcb86b1d6f574e62e9876ad65de41de370c7968949872dfa050cb52bcf099"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"

    ldflags = %W[
      -s -w
      -X knative.dev/client/pkg/commands/version.Version=v#{version}
      -X knative.dev/client/pkg/commands/version.GitRevision=#{Utils.git_head(length: 8)}
      -X knative.dev/client/pkg/commands/version.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/kn"

    generate_completions_from_executable(bin/"kn", "completion")
  end

  test do
    system bin/"kn", "service", "create", "foo",
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
