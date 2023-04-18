class Newt < Formula
  desc "Library for color text mode, widget based user interfaces"
  homepage "https://pagure.io/newt"
  url "https://releases.pagure.org/newt/newt-0.52.23.tar.gz"
  sha256 "caa372907b14ececfe298f0d512a62f41d33b290610244a58aed07bbc5ada12a"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://releases.pagure.org/newt/"
    regex(/href=.*?newt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5df728ad1e151aaac5b625718e46d08da895ca69723d3784468d73769e935afa"
    sha256 cellar: :any,                 arm64_monterey: "10b1d3a167cb58d3395e658ade694a7d1399b055bd3ac73e927b5d72ce6365c5"
    sha256 cellar: :any,                 arm64_big_sur:  "ef5db051a9a6a3e2d4ef1640e9bd457ff7fb93e4bdecf375a616997de030f0c7"
    sha256 cellar: :any,                 ventura:        "ab855ccc5e8616cfb5fde2b1f22280c7d985a865286d2d5a38053d7efb920108"
    sha256 cellar: :any,                 monterey:       "fa3933a096a7fb991019e7136da6904f83f68c1fe22a1cf8fbbaba7bc032d8f9"
    sha256 cellar: :any,                 big_sur:        "5cfff166cb954acea8b020cca6d0e583edf3edfcc0e313d9dfe5e2f77d813104"
    sha256 cellar: :any,                 catalina:       "600d9b87f410ba129edb1fb51d82573e22dba023d69c201ebb8bed5ccbcdb982"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b67e8869197eab4707919551f3f3358d31820cbe3ce3eb7f892682a3e6fa52b0"
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
