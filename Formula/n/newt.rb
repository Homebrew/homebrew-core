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
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "21a582ad976c6c02afb4267f825d5ede7f89498a9389172833c926cd7bf3ba89"
    sha256 cellar: :any, arm64_tahoe:       "b9b1d2a75d8fffb40fa00e1c48305d29c0daafeb6e5ff12bd0f9f1cac9e1eb68"
    sha256 cellar: :any, arm64_sequoia:     "26462f57eba77601690cbdebebacd309f0732a25d3b24fac13b3b7ecfa7455be"
    sha256 cellar: :any, arm64_linux:       "fd0757187cbe4fd237187112f1ee392d126e6c68d93da2cf1ed3d2652464ff40"
    sha256 cellar: :any, x86_64_linux:      "caf7b666af95224258da2b092413cd77f67c5db7c3f695732c6818b5efdd3b3e"
  end

  depends_on "popt"
  depends_on "python@3.14"
  depends_on "s-lang"

  on_macos do
    depends_on "gettext"
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
