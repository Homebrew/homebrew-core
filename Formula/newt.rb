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
    sha256 cellar: :any,                 arm64_monterey: "93a43143160e7432d52429e5aab0dcfda5b17858b4cd3f9921c54b98bd405ea8"
    sha256 cellar: :any,                 arm64_big_sur:  "033f20f9fad1bf00c6e8a8ef8b24525d1184e67008b6c42e40893c8eefb6ccb5"
    sha256 cellar: :any,                 monterey:       "0afdface002d204eff335387f8c5afba4c787836cd773db6f19811eef3a4e6c0"
    sha256 cellar: :any,                 big_sur:        "26e7dffcbe33b1a34a69fb041fdc6740a5b5888351444a8b7f074e16c1f69877"
    sha256 cellar: :any,                 catalina:       "c39688432c5335bb26ddc5149f119a05e4811ac7fc3a0a9d1a9f0c829c3833cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b8bc4c34aaff04b2bf0dc6f8b8094ee11c80b254240a231bca96b91111450c8"
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
