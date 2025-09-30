class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.19.5",
      revision: "0206e6cc118346561b4eeba9c759d10aa36d87e9"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "241c99db5ca5fc7f8d1b7bbbda8e219a06d16154844cda29d5a291d217f146f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfe359967f6851319d2c575120ed6f0156045a3d2a7ba071882a011ea0663db2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d872681659fb568f47ec09296499aaa2af355f31be592fd0c7c9c2148d019847"
    sha256 cellar: :any_skip_relocation, sonoma:        "5355d9ce94a92a3744f3ee185d4c52ce96c295a84aba5462beb4a0b2aeeca1fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e56538d060799fcd39f07eed9f9eec6e65b0d6e905bd0c1ed7c42a32a3fa94d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "540d5c2230b0c6615ee13fd4954a2ffdd7c49e1d855f9aee3c7b8e714687958a"
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
