class Newt < Formula
  desc "Library for color text mode, widget based user interfaces"
  homepage "https://pagure.io/newt"
  url "https://releases.pagure.org/newt/newt-0.52.24.tar.gz"
  sha256 "5ded7e221f85f642521c49b1826c8de19845aa372baf5d630a51774b544fbdbb"
  license "LGPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://releases.pagure.org/newt/"
    regex(/href=.*?newt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e4b261340f37dfb5285bfd8b5dd284f95758caca8d20a469f878a6c73b0331d2"
    sha256 cellar: :any,                 arm64_ventura:  "1a383b56fbc5cae2adcc100e7ab815f2e8eea47bd906d80eea99303072db6a75"
    sha256 cellar: :any,                 arm64_monterey: "ba3f2a5687488c1cdc66397b22b3ca34002436e8373cad2d23587897da557711"
    sha256 cellar: :any,                 sonoma:         "2a57a589ee51e2591dca29db4243a7b53641c40efa3b0d44ed305144ef239f3e"
    sha256 cellar: :any,                 ventura:        "1e490884ea9bf5da5cdf0ab79fa20b1e4e02c2d36853cc533dbaa8855a92baea"
    sha256 cellar: :any,                 monterey:       "e0ce53aa703b820069823b945713e1fdaac547d06b77ff678b88bbb84fa0228a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3125c4ae280adf26b807d5d368b92d01db7942d1dfbae2e550f1e84212f7d026"
  end

  depends_on "popt"
  depends_on "python@3.12"
  depends_on "s-lang"

  on_macos do
    depends_on "gettext"
  end

  def python3
    "python3.12"
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

    (testpath/"test.c").write <<~EOS
      #import <newt.h>
      int main() {
        newtInit();
        newtFinished();
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lnewt"
    system "./test"
  end
end
