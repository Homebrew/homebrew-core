class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.8.0.tar.gz"
  sha256 "41c6273c7b8868e06bbf9d480d5b445b3e7c805c3cbf836fb930dd83de8be29d"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bda374d3eab6fbfddb729dd0222b53bc2029a76673d7085ffee7890b17925d66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "446ec28458292336984f19cd7ddcd00a7dee5ab2c5a26a17e78dcf4b0a482266"
    sha256 cellar: :any_skip_relocation, monterey:       "f386065fdb650a2593db8d2b188a3050972e93b77f64acd8c891d9b4aad21ede"
    sha256 cellar: :any_skip_relocation, big_sur:        "c19284b215a0c2ba0505845e7da08c956fa94218f67622f70e4aacab36e0fec6"
    sha256 cellar: :any_skip_relocation, catalina:       "4b4d9a095b610d7569e7b3dc79fdf8dd361238b60abf52a9a92fd59014b97e66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "399dbe667dac486889dac6a5e9a0f198a4292b9b6f88dd4dd53b1445f9ea7c82"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags

    generate_completions_from_executable(bin/"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "Your context is not set",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end
