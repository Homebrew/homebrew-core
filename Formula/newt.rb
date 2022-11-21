class Newt < Formula
  desc "Library for color text mode, widget based user interfaces"
  homepage "https://pagure.io/newt"
  url "https://releases.pagure.org/newt/newt-0.52.22.tar.gz"
  sha256 "a15efa37e86610b68a942b19a138b44ccb501c234e4c82dab2f5a9b19f7c9e79"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://releases.pagure.org/newt/"
    regex(/href=.*?newt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b17f6125276c6ea8edeb84f03d0db4007db9ffa9f2a7e3dd0d8f4e1ccf0b338c"
    sha256 cellar: :any,                 arm64_monterey: "f7d9a7b2eaff90cd590e1ed1b0b43fa9b171dfea47ddf97e09f115af3917a285"
    sha256 cellar: :any,                 arm64_big_sur:  "a8874b099d758eb7db8201a917e88c0a2d2c4e672eef7bea5d4630cd466006cb"
    sha256 cellar: :any,                 ventura:        "7a195d738d5e20dbd52ba2af08dfb712a6e1f7a3ced0e13b28b16b395b6f3931"
    sha256 cellar: :any,                 monterey:       "253ed4ae344bc4b7a83dfc591f6f61948a1c5d68d462f6f79579738d0474191b"
    sha256 cellar: :any,                 big_sur:        "f18f5b359bf194f03f92bf5788599d48ee1312ba18567b9f82e88a4e72727595"
    sha256 cellar: :any,                 catalina:       "9ea56c85b436611977f70be5257358ca6c09f3a003c0ad87b9b0ae754f796945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea09c23cefc4da0611d5251400a6f173b974b36e93d3b294f809e6c4f9b4de85"
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
