class Newt < Formula
  desc "Library for color text mode, widget based user interfaces"
  homepage "https://pagure.io/newt"
  url "https://pagure.io/releases/newt/newt-0.52.20.tar.gz"
  sha256 "8d66ba6beffc3f786d4ccfee9d2b43d93484680ef8db9397a4fb70b5adbb6dbc"
  revision 1

  bottle do
    cellar :any
    sha256 "b6fcbf4441d9ed5957b34f773606eeba1dcef1beed75fafe4ebac83f72fbc305" => :mojave
    sha256 "092e8f0a4603c337cd7e51d26d3721bd450a3a9ebf6eb0f55bf703f1a3c34cfa" => :high_sierra
    sha256 "eb0b10566d3852909e6f11ad02dd09382cb494d05f1ea4a2371c15abda8cda1c" => :sierra
    sha256 "1a3b16bafddded8ae06bcb5b261c50142b7b7752d4e4cf08d65709a2506edf82" => :el_capitan
    sha256 "78f895d8ee19c343c5846a29699fd8be1f552f8d5c335081df353f8069cd9fa0" => :yosemite
  end

  depends_on "gettext"
  depends_on "popt"
  depends_on "s-lang"

  def install
    args = ["--prefix=#{prefix}", "--without-tcl"]

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

    system "./configure", *args
    system "make", "install"
  end

  test do
    ENV["TERM"] = "xterm"
    system "python2.7", "-c", "import snack"

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
