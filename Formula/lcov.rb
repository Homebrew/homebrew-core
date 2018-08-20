class Lcov < Formula
  desc "Graphical front-end for GCC's coverage testing tool (gcov)"
  homepage "https://github.com/linux-test-project/lcov"
  url "https://downloads.sourceforge.net/ltp/lcov-1.13.tar.gz"
  sha256 "44972c878482cc06a05fe78eaa3645cbfcbad6634615c3309858b207965d8a23"
  head "https://github.com/linux-test-project/lcov.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b95fce4c15aba34863f433b11bb1476b11b457f6367a84de8a871f882c19b354" => :mojave
    sha256 "ecd3e27cbeedb34321d9ce5decd4310e3ea0c73956a20317fec3ac14dc71364c" => :high_sierra
    sha256 "b37e8592f6cedb734dea0c35daec9b4d701b5739dbe316b094c090179ff96dd3" => :sierra
    sha256 "5b54e7b2f4361673debf9905109c302bed2bb5b542ca093598053357bbcd9065" => :el_capitan
    sha256 "5b54e7b2f4361673debf9905109c302bed2bb5b542ca093598053357bbcd9065" => :yosemite
  end

  def install
    inreplace %w[bin/genhtml bin/geninfo bin/lcov],
      "/etc/lcovrc", "#{prefix}/etc/lcovrc"
    system "make", "PREFIX=#{prefix}", "BIN_DIR=#{bin}", "MAN_DIR=#{man}", "install"
  end

  test do
    system "#{bin}/lcov", "--version"
  end
end
