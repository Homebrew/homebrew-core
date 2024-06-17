class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/2.28.0.tar.gz"
  sha256 "d4a8963ca762b2b962b7444bdeb3b984ed552a536f1669191b8c814b1125d9c5"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2bd30054bb49ae19e3897c981abbb24b35e7765a7120b9b0fa663d4652c6342c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f78a2eb2effc4e3f465a89410286995f452213e08137e4161bd1f0e1a38a8f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "981962b0131cf42a572b662fd7f5ee1f7d5f0b3dbf48091752d194af00ee64c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ed5f2dad60c4f70b455dfcd63f58a48a3cb47ee01365b7d35ffedac4ec11caa"
    sha256 cellar: :any_skip_relocation, ventura:        "a3002ee30f2373fc63d8c8730553653ca66af820d129201118a06d4bdbc82138"
    sha256 cellar: :any_skip_relocation, monterey:       "f2d229d5cb28fd1b698bdad88540bfc04d5bfe6d23b002dd57b8ee18a47e523a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92a0f7ae5f7f4223d253b1b0c871f286425f3d7cb03665ece98192cec8a7aec6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:), "-tags", tags

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
