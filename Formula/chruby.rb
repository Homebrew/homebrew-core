class Chruby < Formula
  desc "Ruby environment tool"
  homepage "https://github.com/postmodern/chruby#readme"
  url "https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz"
  sha256 "7220a96e355b8a613929881c091ca85ec809153988d7d691299e0a16806b42fd"
  head "https://github.com/postmodern/chruby.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "004f825f798a41ffb3c9576aa3b77e7b8cef227287725818f5d3f1a779b12de6" => :catalina
    sha256 "4b3e7d6e76cd5d914b0bb4871a0a0f33c9b997a9c579ca4450191c87c3dc4f53" => :mojave
    sha256 "d59074fe39429eb9979acd0e81e6b9a142aa73595971cee42ab91bbe850c6105" => :high_sierra
    sha256 "17dc507695fed71749b5a58152d652bb7b92a4574f200b631a39f5f004e86cca" => :sierra
    sha256 "ff70dff83817f093d39384a40d3dfb2aaccc1cbe475d58383d4ef157085f2c64" => :el_capitan
    sha256 "eb14810c552b693c5ae82a577be81398e7dfeadc5489666bb0ff89581f09bfe4" => :yosemite
    sha256 "c7ede5a22e512d3c22406f222b539fe05b78dfb9721cfff8ce94ed0357883ba5" => :mavericks
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
