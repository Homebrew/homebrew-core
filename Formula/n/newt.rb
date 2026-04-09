class Newt < Formula
  desc "Library for color text mode, widget based user interfaces"
  homepage "https://pagure.io/newt"
  url "https://releases.pagure.org/newt/newt-0.52.25.tar.gz"
  sha256 "ef0ca9ee27850d1a5c863bb7ff9aa08096c9ed312ece9087b30f3a426828de82"
  license "LGPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://releases.pagure.org/newt/"
    regex(/href=.*?newt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aa18d4ccbf4acef83986a3b12ba9a530ba02cf6b6c84d88865e2e838ce4288a8"
    sha256 cellar: :any,                 arm64_sequoia: "0fa5a58b27113fbc099d7fde9a289fb4951ceeec4a05ea231d9cdaf3be1d0718"
    sha256 cellar: :any,                 arm64_sonoma:  "ea2c081bd723fcca5ce9c754a795c59a8f9077e299b54eb310a955b6c261c33f"
    sha256 cellar: :any,                 sonoma:        "2c60203dd3204211de30dc48baaf246fc11aaa7e653805b31bc381bdd650cc04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "364d416e80eb3bd0c3b0985abcb98191445397cffa5cd3c5161626d3ee632990"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b360a1c7abe35cfa3382b5ac27ec36d2a28264fd2c62285ecfbac2bd0fe12de"
  end

  depends_on "popt"
  depends_on "python@3.14"
  depends_on "s-lang"

  on_macos do
    depends_on "gettext"
  end

  def python3
    "python3.14"
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
              "#{lib}/#{python3}/site-packages"
    end

    system "./configure", "--prefix=#{prefix}", "--without-tcl", "--with-python=#{python3}"
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
