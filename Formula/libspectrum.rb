class Libspectrum < Formula
  desc "Support library for ZX Spectrum emulator"
  homepage "https://fuse-emulator.sourceforge.io/libspectrum.php"
  url "https://downloads.sourceforge.net/project/fuse-emulator/libspectrum/1.5.0/libspectrum-1.5.0.tar.gz"
  sha256 "a353cb46e9b1a281061d816353ea010d0a6fe78e6a17aa0b7b74271ca5e4acfc"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/libspectrum[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a4274845dd06d14a86fad39c42f32201b7491d19110dbc26f04fbc2602513c2f"
    sha256 cellar: :any,                 arm64_big_sur:  "72eec781fcd9e66de8e08da5aa323f9e5bd8de3ec64ad1202fead40e65b3c3c3"
    sha256 cellar: :any,                 monterey:       "4f48bde63b6b67f8ed827111ad0a0e8223e2095ab7b6e869cdb9e44a9e6524eb"
    sha256 cellar: :any,                 big_sur:        "4c73d5c70e9669a07ad7fcc97b5a967b3b818a764d4c5a00992095f93d8b5505"
    sha256 cellar: :any,                 catalina:       "9c98e034990260a5011d0587aaf081c7d761c5dd90299c9d38bc93fd70bb4fac"
    sha256 cellar: :any,                 mojave:         "256b58b14183966bc73f607b85f805571bbaf2f9c861cb6377636914faca2db0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53cabe107824fd8ee9d04b022176d5ae1a7901626fe54b7490eb31c8569725d7"
  end

  head do
    url "https://svn.code.sf.net/p/fuse-emulator/code/trunk/libspectrum"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "audiofile"
  depends_on "glib"
  depends_on "libgcrypt"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "libspectrum.h"
      #include <assert.h>

      int main() {
        assert(libspectrum_init() == LIBSPECTRUM_ERROR_NONE);
        assert(strcmp(libspectrum_version(), "#{version}") == 0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lspectrum", "-o", "test"
    system "./test"
  end
end
