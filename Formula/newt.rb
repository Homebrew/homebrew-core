class Newt < Formula
  desc "Library for color text mode, widget based user interfaces"
  homepage "https://pagure.io/newt"
  url "https://releases.pagure.org/newt/newt-0.52.21.tar.gz"
  sha256 "265eb46b55d7eaeb887fca7a1d51fe115658882dfe148164b6c49fccac5abb31"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://releases.pagure.org/newt/"
    regex(/href=.*?newt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e9300824da839821c6c8baab0bf22e743db69ecabe7002a6cd08421e922dfbd8"
    sha256 cellar: :any,                 arm64_big_sur:  "5b125ba2ac186a9b1163e5546a3669d19dbd1c9703060a2ac358e4ca784ec2b9"
    sha256 cellar: :any,                 monterey:       "273e084363837afb61026e2a45d9900469ec1e13a6c7cd4f194e75f1a34e4509"
    sha256 cellar: :any,                 big_sur:        "93469c4ded76db63f8ac56143c9d110e18ff8c92f25857a7bb2955de63eb19cc"
    sha256 cellar: :any,                 catalina:       "82ea49582f5bcf3bbaf6a39d4d6128c966889eaff682bf83601954c995ee1276"
    sha256 cellar: :any,                 mojave:         "2b902ecc6fc52b2f2681eb23e4eb568684a018deeada88e5a920952de8cc1080"
    sha256 cellar: :any,                 high_sierra:    "7a88cbe033eb207df57a6410f19339975a672e331c073e3ee79e467652c8753c"
    sha256 cellar: :any,                 sierra:         "4d82531bb783ba5e3f8a64150582e61b2fd4a9fb8be96d0bee88fa3bbe0dc3c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1957777c814f7cc0952008329312c8f8e1f281b18f8f4256b55f206a02630b89"
  end

  depends_on "gettext"
  depends_on "popt"
  depends_on "s-lang"

  on_linux do
    depends_on "python@3.9"
  end

  def install
    args = ["--prefix=#{prefix}", "--without-tcl"]

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
