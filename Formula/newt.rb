class Newt < Formula
  desc "Library for color text mode, widget based user interfaces"
  homepage "https://pagure.io/newt"
  url "https://releases.pagure.org/newt/newt-0.52.21.tar.gz"
  sha256 "265eb46b55d7eaeb887fca7a1d51fe115658882dfe148164b6c49fccac5abb31"
  license "LGPL-2.0-or-later"
  revision 3

  livecheck do
    url "https://releases.pagure.org/newt/"
    regex(/href=.*?newt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1453d0f02560c1819fd5b9aa740ee93832bbbc97669cff87711256a73b7f9223"
    sha256 cellar: :any,                 arm64_monterey: "6b4fc5ebdd522738f81b6396736353a5caefd04d45e48403a7ab29dd04c70b00"
    sha256 cellar: :any,                 arm64_big_sur:  "9349d37eebeab520f8a9ce726ff5ca4e333d07a70534832bee1b3652c5b97c8a"
    sha256 cellar: :any,                 ventura:        "12738c56633e4e9feafb5cc6cce14755abdff5aea41689fbf652b66b64125ff8"
    sha256 cellar: :any,                 monterey:       "5c5796570d5b8e571730c81222929180bca792e82b5b62914d91c94039088f3b"
    sha256 cellar: :any,                 big_sur:        "eea45650f566b8de134d82b47874b79adcc75be9da163586341814e346aa2e4c"
    sha256 cellar: :any,                 catalina:       "06c43690d0973a72b93eba9fdda86e6738f67039f01095f6c1d170812f35c110"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb86234d4f8cd90672f29a2932873d988516623aea98b53107ef147fcf0e1e7b"
  end

  depends_on "popt"
  depends_on "python@3.11"
  depends_on "s-lang"

  on_macos do
    depends_on "gettext"
  end

  def python3
    "python3.11"
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
