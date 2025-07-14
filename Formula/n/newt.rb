class Newt < Formula
  desc "Library for color text mode, widget based user interfaces"
  homepage "https://pagure.io/newt"
  url "https://releases.pagure.org/newt/newt-0.52.25.tar.gz"
  sha256 "ef0ca9ee27850d1a5c863bb7ff9aa08096c9ed312ece9087b30f3a426828de82"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://releases.pagure.org/newt/"
    regex(/href=.*?newt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "ea9696a197929f238a1b30a02fefcf818e3b858d8203822c941c9a687609c1fc"
    sha256 cellar: :any,                 arm64_sonoma:  "5ca2f04f2776a526ef75eb1021bc62b913014533e6ba23aa7698f55ab04c2a6d"
    sha256 cellar: :any,                 arm64_ventura: "effe0810ddce425071a2977345c49b817169da634debc65495804edf6f8aa479"
    sha256 cellar: :any,                 sonoma:        "66fa052a1ffa07040d784b9673cd691378e3511567899b0912156023cf1540d4"
    sha256 cellar: :any,                 ventura:       "4e2d05a8b49ac5145b7d2cc12912ee1cb4d95af69455556f3cb2c890c6b1f8ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "686377c6653387d4c4099330479420648f484a0846d817bf8be4f81b1261919f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dd7eb05b5dce0dad968eceac5f75d67354cb1cf8f1421dafa2e6dbb1e81b2bb"
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
    inreplace "Makefile.in" do |s|
      if OS.mac?
        # name libraries correctly
        # https://bugzilla.redhat.com/show_bug.cgi?id=1192285
        s.gsub! "libnewt.$(SOEXT).$(SONAME)", "libnewt.$(SONAME).dylib"
        s.gsub! "libnewt.$(SOEXT).$(VERSION)", "libnewt.$(VERSION).dylib"

        # don't link to libpython.dylib
        # causes https://github.com/Homebrew/homebrew/issues/30252
        # https://bugzilla.redhat.com/show_bug.cgi?id=1192286
        s.gsub! "`$$pyconfig --ldflags --embed || $$pyconfig --ldflags`", '"-undefined dynamic_lookup"'
      end

      # install python modules in Cellar rather than global site-packages
      s.gsub! "`$$ver -c \"import sysconfig; print(sysconfig.get_path('platlib'))\"`",
              "#{lib}/python3.13/site-packages"
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
