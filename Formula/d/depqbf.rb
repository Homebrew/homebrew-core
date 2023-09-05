class Depqbf < Formula
  desc "Solver for quantified boolean formulae (QBF)"
  homepage "https://lonsing.github.io/depqbf/"
  url "https://github.com/lonsing/depqbf/archive/version-6.03.tar.gz"
  sha256 "9684bb1562bfe14559007401f52975554373546d3290a19618ee71d709bce76e"
  license "GPL-3.0-or-later"
  head "https://github.com/lonsing/depqbf.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "221268b1bc924d55e1f8f3554b85f4ae91475792834f699217b03cce46ea63a3"
    sha256 cellar: :any,                 arm64_monterey: "204b1a36f581b9609dcf0a47c0778169d0f26748e6a5fd869a1e7bba826be6f8"
    sha256 cellar: :any,                 arm64_big_sur:  "afc477a7b941f95abf0a3e7db86d60b2ee9ef9e8b2f4ecb84d84044a9dbb0bdf"
    sha256 cellar: :any,                 ventura:        "209da2f6f71ffd18105f99dd6333a0547865da8725e109138fe9e3e138b8300c"
    sha256 cellar: :any,                 monterey:       "135536ee418fef5b3e8002301dca15913770d3b2d81c8b08b9bb2fef67bb56cc"
    sha256 cellar: :any,                 big_sur:        "e86513b7cd6ad6ac68c7aa8a1738d8586fe6e20a7a46237dcbc3d54d735ff6d0"
    sha256 cellar: :any,                 catalina:       "432518e2ccee50695a9e79b4fe558142d78945ef96fcdbf7cccf090d72ec6543"
    sha256 cellar: :any,                 mojave:         "210b2363035bf7772b275036b26938a8a286da0ddbd93d29a72cbbcb16237c23"
    sha256 cellar: :any,                 high_sierra:    "7c956f3b4e86d6f60e90dde3e25f6b5ce75f2ba75e756c9e4dd6debe46d2ddea"
    sha256 cellar: :any,                 sierra:         "fea1eb8ca62fccc5ce43b0a645fb67feffbf97c5a343d0ea6c9a015c37e24ccc"
    sha256 cellar: :any,                 el_capitan:     "3229005d870984af6beee544d5178094fc859525bd96552ac42301860c175f5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e13e19078a40264180e470c713e834493e8189f3b45a263318f17d1b4830f73"
  end

  resource "nenofex" do
    url "https://github.com/lonsing/nenofex/archive/version-1.1.tar.gz"
    sha256 "972755fd9833c9cd050bdbc5a9526e2b122a5550fda1fbb3ed3fc62912113f05"
  end

  resource "picosat" do
    url "http://fmv.jku.at/picosat/picosat-960.tar.gz"
    sha256 "edb3184a04766933b092713d0ae5782e4a3da31498629f8bb2b31234a563e817"
  end

  def install
    (buildpath/"nenofex").install resource("nenofex")
    (buildpath/"picosat-960").install resource("picosat")
    system "./compile.sh"
    bin.install "depqbf"
    lib.install "libqdpll.a"
    if OS.mac?
      lib.install "libqdpll.1.0.dylib"
    else
      lib.install "libqdpll.so.1.0"
    end
  end

  test do
    system "#{bin}/depqbf", "-h"
  end
end
