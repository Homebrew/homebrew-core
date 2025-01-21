class Newt < Formula
  desc "Library for color text mode, widget based user interfaces"
  homepage "https://pagure.io/newt"
  url "https://releases.pagure.org/newt/newt-0.52.24.tar.gz"
  sha256 "5ded7e221f85f642521c49b1826c8de19845aa372baf5d630a51774b544fbdbb"
  license "LGPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://releases.pagure.org/newt/"
    regex(/href=.*?newt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0dcef640f944ee4c90cd5a2ed528681e94dc9b43ddfe156c01edff8d6a5cade4"
    sha256 cellar: :any,                 arm64_sonoma:  "3ae123a831c21b56e66b175e428e5f90ec223c317af3db8dae551d502d9add01"
    sha256 cellar: :any,                 arm64_ventura: "131824dbbd51648d4db88157885cee03db0bd1145d69fcdc6d01c64c4ef2519c"
    sha256 cellar: :any,                 sonoma:        "79766179662f464005df2db159e98fe8286ce0670ec18e8a29f46d843ad14e49"
    sha256 cellar: :any,                 ventura:       "635561263b0b1267d029fb6d9cb34a235eeeda85116b784f3a603cf3fea83ec0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5942b5e99097a17fd736ab763c7af5dcc4f020aff7ab94befd41e56ce3f694d"
  end

  depends_on "popt"
  depends_on "python@3.13"
  depends_on "s-lang"

  on_macos do
    depends_on "gettext"
  end

  def python3
    "python3.13"
  end

  def install
    if OS.mac?
      inreplace "Makefile.in" do |s|
        # name libraries correctly
        # https://bugzilla.redhat.com/show_bug.cgi?id=1192285
        s.gsub! "libnewt.$(SOEXT).$(SONAME)", "libnewt.$(SONAME).dylib"
        s.gsub! "libnewt.$(SOEXT).$(VERSION)", "libnewt.$(VERSION).dylib"

        # don't link to libpython.dylib
        # causes https://github.com/Homebrew/homebrew/issues/30252
        # https://bugzilla.redhat.com/show_bug.cgi?id=1192286
        s.gsub! "`$$pyconfig --ldflags`", '"-undefined dynamic_lookup"'
        s.gsub! "`$$pyconfig --libs`", '""'
      end
    end

    system "./configure", "--prefix=#{prefix}", "--without-tcl", "--with-python=#{python3}"
    system "make", "install"
  end

  test do
    ENV["TERM"] = "xterm"
    system python3, "-c", "import snack"

    (testpath/"test.c").write <<~C
      #import <newt.h>
      int main() {
        newtInit();
        newtFinished();
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lnewt"
    system "./test"
  end
end
