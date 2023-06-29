class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.4.4.tar.gz"
  sha256 "48cfcb66fb04ae48c0169d0767f59503f7aa43b224724d04de96d43857c7ab2c"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a198ffe5bac5403e29a55cdf874b49dc7360b201ae21ae12559ed3cb62a49ace"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5e4f82ee65f093e868e31007a89f18d5cb4a6fbf1be65cfa6bed2e85cef3fde"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00d4f406734cebef3882c1b7be41565787dd4927db188567b73dd6aa52b9fa3d"
    sha256 cellar: :any_skip_relocation, ventura:        "edf99288dd3c0174df4b4552515e492a486da00da9095cfcd35c1ecbf646bfc9"
    sha256 cellar: :any_skip_relocation, monterey:       "0b8d4c88f7bc2d87279f5326526c2f8950828de8321499a55b5999046f3edcc6"
    sha256 cellar: :any_skip_relocation, big_sur:        "4719fb8be04064c0e6c2725e7eaa5b18c1fc9576d7959e842e9efe860fd742e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95d55cf893e4ab5c7c6f6316a7c194dea4b6b890f3911c15823ba2bcebed3511"
  end

  depends_on "go" => [:build, :test]

  def install
    cd "cmd/gf" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    output = shell_output("#{bin}/gf --version 2>&1")
    assert_match "GoFrame CLI Tool v#{version}, https://goframe.org", output
    assert_match "GoFrame Version: cannot find go.mod", output

    output = shell_output("#{bin}/gf init test 2>&1")
    assert_match "you can now run \"cd test && gf run main.go\" to start your journey, enjoy!", output
  end
end
