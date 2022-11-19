class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.9.0.tar.gz"
  sha256 "45ffb28607eecc5737d01cee3839c10f250ab9e60129b6491beef95156c9843d"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88ea3e2781da070415e7a5551bba9a469e28da3b96a1a6acfe3d27c12af45dd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b042a09d54a1851c8f722500a6e21c8d83d198e909e989428fa811337a80d12"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b2c2450f097107c815f3f77b5eaa5790ce20a64737d4159311034e17b2ae6cf"
    sha256 cellar: :any_skip_relocation, ventura:        "ceb77aae6879806bbb89f28781cb6415f3ece3b83a6579f39efa7944460c7358"
    sha256 cellar: :any_skip_relocation, monterey:       "9093eb59f549f9d428a4ce5150bedecfc3412477bc561c215998bc9a988ae387"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f5097ddc9a352de6f092a486817bc9e94da33fb2623ac750ac30efaddde9144"
    sha256 cellar: :any_skip_relocation, catalina:       "425fdc233f0fd39141894870034c73f487ba2ca3bf8adc643deafcf8af1eff6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a13b65dc8d82a224c6b7dabb8614e93d51404e147cb5801cf31d8d53e635ffd"
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
