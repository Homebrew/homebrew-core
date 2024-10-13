class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.15.0",
      revision: "59dd72a2407e6ce6d12e9df7a5bf4e87941a550e"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c42b2ee3fa22e70e49de0ea5a67fa55b600f77e7a30a6ab5a4590d7e063b5224"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f214605c37805783058d0e347cba6118e33885c807d343af05cf4fdb09984cae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f214605c37805783058d0e347cba6118e33885c807d343af05cf4fdb09984cae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f214605c37805783058d0e347cba6118e33885c807d343af05cf4fdb09984cae"
    sha256 cellar: :any_skip_relocation, sonoma:         "732bf96fdc66572095563d4e4b1a7d62fccb294d34c5af84fd8dc0a89363a406"
    sha256 cellar: :any_skip_relocation, ventura:        "732bf96fdc66572095563d4e4b1a7d62fccb294d34c5af84fd8dc0a89363a406"
    sha256 cellar: :any_skip_relocation, monterey:       "732bf96fdc66572095563d4e4b1a7d62fccb294d34c5af84fd8dc0a89363a406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "daab235040f375a78e92474dfa2cee922e8f642afd1d5f8c8fbda5c0b8e5aeb7"
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
