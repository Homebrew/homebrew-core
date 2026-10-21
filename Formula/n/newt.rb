class Newt < Formula
  desc "Library for color text mode, widget based user interfaces"
  homepage "https://pagure.io/newt"
  url "https://releases.pagure.org/newt/newt-0.52.25.tar.gz"
  sha256 "ef0ca9ee27850d1a5c863bb7ff9aa08096c9ed312ece9087b30f3a426828de82"
  license "LGPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://releases.pagure.org/newt/"
    regex(/href=.*?newt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "67659b3a88bab7a5b1e40959da03af86335721a3f902195fcdb6d863a36ee27e"
    sha256 cellar: :any, arm64_tahoe:       "6c3b46b21e3e56eed7d1c15e3275fb9cba9566dcf8409ac612c01dc52798f75e"
    sha256 cellar: :any, arm64_sequoia:     "5b85a5aed10e464fcc2c0340ce6307966b67df7f68826e977a5b57e479c82187"
    sha256 cellar: :any, arm64_linux:       "5ed5248d6a95bc52f8c857ee415c8622d0fb8193e55b606498eec0e850c0667b"
    sha256 cellar: :any, x86_64_linux:      "0251a43dc3ea6297353d273300315d92d3c9d2f1c68b50df80cbe39db136d796"
  end

  depends_on "popt"
  depends_on "python@3.15"
  depends_on "s-lang"

  on_macos do
    depends_on "gettext"
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
              (prefix/Language::Python.site_packages(python3)).to_s
    end

    # The Makefile also uses the `--with-python` value as a build directory name, so it must not be a path
    system "./configure", "--prefix=#{prefix}", "--without-tcl", "--with-python=#{python3.basename}"
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
