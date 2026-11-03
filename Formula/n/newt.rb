class Newt < Formula
  desc "Library for color text mode, widget based user interfaces"
  homepage "https://gitlab.com/newt-ui/newt"
  url "https://gitlab.com/newt-ui/newt/-/releases/0.52.25/downloads/newt-0.52.25.tar.gz"
  sha256 "ef0ca9ee27850d1a5c863bb7ff9aa08096c9ed312ece9087b30f3a426828de82"
  license "LGPL-2.0-or-later"
  revision 2
  compatibility_version 1

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "a9f3e8cd8dde3c9954293d474798f020a3b7866a4073c11da7042a3ca871dfc9"
    sha256 cellar: :any, arm64_tahoe:       "d0a7c444dc42b1d60566ba9c09075e15d849c8ab98ac200bf4ca3a4935904879"
    sha256 cellar: :any, arm64_sequoia:     "81ed2a2917d7b6f396b3d48045e230f7919aba2217ce03a415f5c4274578dd97"
    sha256 cellar: :any, arm64_linux:       "8c9167131e2c674b91b09bdee6fd7c77ca86e389d298ce4955c146c903e2ac1d"
    sha256 cellar: :any, x86_64_linux:      "0fae30604b71c713b41ac6f768dbd883c35e1ad7e76f1db0c82cc54d6e887fde"
  end

  head do
    url "https://gitlab.com/newt-ui/newt.git", branch: "master"

    depends_on "autoconf" => :build

    on_linux do
      depends_on "gettext" => :build
    end
  end

  depends_on "python@3.15" => [:build, :test]
  depends_on "popt"
  depends_on "s-lang"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./autogen.sh" if build.head?

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
              (prefix/Language::Python.site_packages(python3)).to_s
    end

    # The Makefile also uses the `--with-python` value as a build directory name, so it must not be a path
    system "./configure", "--prefix=#{prefix}", "--without-tcl", "--with-python=#{python3.basename}"
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
