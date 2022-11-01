class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "7e272eaceeb80bc5efb1504dcc47072d0137dad9b2f3db75b1d672ddb6dd737d"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97f564ed3f84c7d6713f68fa7463aaf911dcaf198cd30963cf3b6e70bcac7065"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6fcd2c3f87c8284a6490130f5b92fce2e3f548e8f8ce83f26d4d49d9d4a3b03c"
    sha256 cellar: :any_skip_relocation, monterey:       "116598a2e342bc81c3b814f027d92b67237ac5e3a62224299a4c4eadd0e58c08"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7f39edd32b5226de239695c4e9e270fb125063e5239211510b34e3716a38857"
    sha256 cellar: :any_skip_relocation, catalina:       "33b2c723a6b454c4eca1eebb1cb022c66b74ed4cffa6bc49e4baab2efea42f7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae17a10c4bc87cc2c7b0b1f38bac064a5b46770127fd03de66614956f1e5c8f8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
