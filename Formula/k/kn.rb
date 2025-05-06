class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.18.0",
      revision: "96721e598f770d3cd9ee1f0a437bf45bb7951b54"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3034a9a7ed80e2919485a4e85ec962d428a0c0cbb9864d77589db2b5f5ccfb97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "297d162c0faefc3c0dec04a54d9dd4b1a49e434dccb9d5b25896ac112da6f28c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "82101a5958dc2f085b875e8ef6cc879e4cb9238e295355ee6f8ad44fe1cd2aad"
    sha256 cellar: :any_skip_relocation, sonoma:        "d348f6ac06a0d063cd4790f2adcdb328dea432e3a97ffb8442ac70c8bf9505c1"
    sha256 cellar: :any_skip_relocation, ventura:       "3dabd5c19f652132ad80cf8a811b6dd00675547bd1a0b9b8956bb0f00754ab58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ab87d14d46a95b677faf2948df6704540e3fdd1558640c9cd2c7ab48ec48820"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3161226ee2880c1f8c650d8ad4cb13d1cc8f69fc7d2e8563566b1e77bb113250"
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
