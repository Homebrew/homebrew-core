class Chmlib < Formula
  desc "Library for dealing with Microsoft ITSS/CHM files"
  homepage "http://www.jedrea.com/chmlib/"
  url "http://www.jedrea.com/chmlib/chmlib-0.40.tar.gz"
  mirror "https://download.tuxfamily.org/slitaz/sources/packages/c/chmlib-0.40.tar.gz"
  sha256 "512148ed1ca86dea051ebcf62e6debbb00edfdd9720cde28f6ed98071d3a9617"
  license "LGPL-2.1"

  livecheck do
    url :homepage
    regex(/href=.*?chmlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 monterey:     "4d4a29e60712457e4ea3838947a95959dbc0f68338514edd3817d6ee122afbf4"
    sha256 cellar: :any,                 big_sur:      "af369d3e427b36281f053f65a0d5be2a269c2a0fb80c87443baa066892d0652c"
    sha256 cellar: :any,                 catalina:     "96d7cb33260c72012f24f383054b7f2505f815f0e3e24298229b5712f8a66cfa"
    sha256 cellar: :any,                 mojave:       "1718a0a9343788718b4207596ebff457f5214879319292cc1608254374720944"
    sha256 cellar: :any,                 high_sierra:  "426b95744d071ad76399ee240400ab74bcec9057735cbfeb2d433501105060ef"
    sha256 cellar: :any,                 sierra:       "9781c76f933beca002df542d2db0644e51766568d9399f9e73dc39b9e896f539"
    sha256 cellar: :any,                 el_capitan:   "6b834a6ae6e95f8daaa726fd6ae1a2d3e60335f98862fea9e790c24e5a6411d1"
    sha256 cellar: :any,                 yosemite:     "bdc19058cbf1690e960bd88d06f6c8b2ff47f8b743947eb82c259ba394881a65"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "61a085287bba377e847d027575fd848cbadc0f6b5bd8f2efc008cc54d8f32d32"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-io64", "--enable-examples", "--prefix=#{prefix}"
    system "make", "install"
  end
end
