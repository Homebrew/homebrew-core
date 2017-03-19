class Newt < Formula
  desc "Library for color text mode, widget based user interfaces"
  homepage "https://pagure.io/newt"
  url "https://pagure.io/releases/newt/newt-0.52.20.tar.gz"
  sha256 "8d66ba6beffc3f786d4ccfee9d2b43d93484680ef8db9397a4fb70b5adbb6dbc"

  bottle do
    cellar :any
    sha256 "20499cdbbf4075b511a7ea24fc8a4a6f303873b5903aac37578a603a9744d586" => :sierra
    sha256 "87bfa0e43bd4bfecdedc8995fbd509bb7a7b4f94ea932f203ae95fd037a91eb3" => :el_capitan
    sha256 "9df1357a08367454f2588dbe414ebce74352cdd230262ee7d08ab4ec169b3019" => :yosemite
    sha256 "44f755d2e9f16c715366b80b2c1fe65b73c42b486453e71c45c2702e32e61e10" => :mavericks
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
    system "python", "-c", "import snack"
    (testpath/"test.c").write <<-EOS.undent
      #import <newt.h>
      int main() {
        newtInit();
        newtFinished();
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-lnewt"
    system "./test"
  end
end
