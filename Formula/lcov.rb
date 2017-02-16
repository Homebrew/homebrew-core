class Lcov < Formula
  desc "Graphical front-end for GCC's coverage testing tool (gcov)"
  homepage "https://ltp.sourceforge.net/coverage/lcov.php"
  url "https://downloads.sourceforge.net/ltp/lcov-1.13.tar.gz"
  sha256 "44972c878482cc06a05fe78eaa3645cbfcbad6634615c3309858b207965d8a23"
  head "https://github.com/linux-test-project/lcov.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b37e8592f6cedb734dea0c35daec9b4d701b5739dbe316b094c090179ff96dd3" => :sierra
    sha256 "5b54e7b2f4361673debf9905109c302bed2bb5b542ca093598053357bbcd9065" => :el_capitan
    sha256 "5b54e7b2f4361673debf9905109c302bed2bb5b542ca093598053357bbcd9065" => :yosemite
  end

  def install
    inreplace %w[bin/genhtml bin/geninfo bin/lcov],
      "/etc/lcovrc", "#{prefix}/etc/lcovrc"
    system "make", "PREFIX=#{prefix}", "BIN_DIR=#{bin}", "MAN_DIR=#{man}", "install"
  end
end
