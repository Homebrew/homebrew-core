class Chruby < Formula
  desc "Ruby environment tool"
  homepage "https://github.com/postmodern/chruby#readme"
  url "https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz"
  sha256 "7220a96e355b8a613929881c091ca85ec809153988d7d691299e0a16806b42fd"
  license "MIT"
  head "https://github.com/postmodern/chruby.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "97ca44a014def181a1bd3cacb5ff86783c6fddb1d1262336e9765d14a7d5959a"
    sha256 cellar: :any_skip_relocation, big_sur:       "16f188427ecc5432c18a004f567b73a8138fd2c2010d76821843e3804663fc02"
    sha256 cellar: :any_skip_relocation, catalina:      "004f825f798a41ffb3c9576aa3b77e7b8cef227287725818f5d3f1a779b12de6"
    sha256 cellar: :any_skip_relocation, mojave:        "4b3e7d6e76cd5d914b0bb4871a0a0f33c9b997a9c579ca4450191c87c3dc4f53"
    sha256 cellar: :any_skip_relocation, high_sierra:   "d59074fe39429eb9979acd0e81e6b9a142aa73595971cee42ab91bbe850c6105"
    sha256 cellar: :any_skip_relocation, sierra:        "17dc507695fed71749b5a58152d652bb7b92a4574f200b631a39f5f004e86cca"
    sha256 cellar: :any_skip_relocation, el_capitan:    "ff70dff83817f093d39384a40d3dfb2aaccc1cbe475d58383d4ef157085f2c64"
    sha256 cellar: :any_skip_relocation, yosemite:      "eb14810c552b693c5ae82a577be81398e7dfeadc5489666bb0ff89581f09bfe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bea6c750e5ce28f5a8ade003baef8a42bcbdf2b376e2d4ae8e12c7b3b112fef6"
    sha256 cellar: :any_skip_relocation, all:           "977cf9319a21ddbbd26d3f0a43ed75825eb2a514bdce56b4045e5214732ec13b"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  def caveats
    <<~EOS
      Add the following to the ~/.bash_profile or ~/.zshrc file:
        source #{opt_pkgshare}/chruby.sh

      To enable auto-switching of Rubies specified by .ruby-version files,
      add the following to ~/.bash_profile or ~/.zshrc:
        source #{opt_pkgshare}/auto.sh
    EOS
  end

  test do
    assert_equal "chruby version #{version}", shell_output("#{bin}/chruby-exec --version").strip
  end
end
