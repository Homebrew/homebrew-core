class Newt < Formula
  desc "Library for color text mode, widget based user interfaces"
  homepage "https://pagure.io/newt"
  url "https://releases.pagure.org/newt/newt-0.52.21.tar.gz"
  sha256 "265eb46b55d7eaeb887fca7a1d51fe115658882dfe148164b6c49fccac5abb31"
  license "LGPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://releases.pagure.org/newt/"
    regex(/href=.*?newt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ba9ab9973ca7804fceda2fbdb82b2ce93486f855f6310d3ef739045a2d6cdede"
    sha256 cellar: :any,                 arm64_big_sur:  "6c795ee83da9eeaa36c30296b15ea5383c7d0d49d6f8128baac3f25ea41a09e6"
    sha256 cellar: :any,                 monterey:       "f798d2745a79ce24fbda942067341e83c6ceba3717eeacf5aa95b861fb64a1e8"
    sha256 cellar: :any,                 big_sur:        "b4b973be7df201c92b09765adb2aa821157d334e271dd0d73d853229eacdd27c"
    sha256 cellar: :any,                 catalina:       "7a3f57dddb0be9c1f628638ce67f794c1cf33472d09bc48af7f9c60db92f18f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b91288367ad2b36bc9054fe9800f04f1c0bca7fd3d4232f86e5504520fa97ccc"
  end

  depends_on "gettext"
  depends_on "popt"
  depends_on "python@3.10"
  depends_on "s-lang"

  def install
    xy = Language::Python.major_minor_version("python3")
    args = %W[--prefix=#{prefix} --without-tcl --with-python=python#{xy}]

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

    system "./configure", *args
    system "make", "install"
  end

  test do
    ENV["TERM"] = "xterm"
    system Formula["python@3.10"].opt_bin/"python3", "-c", "import snack"

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
