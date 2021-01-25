class Libstfl < Formula
  desc "Library implementing a curses-based widget set for terminals"
  homepage "http://www.clifford.at/stfl/"
  url "http://www.clifford.at/stfl/stfl-0.24.tar.gz"
  sha256 "d4a7aa181a475aaf8a8914a8ccb2a7ff28919d4c8c0f8a061e17a0c36869c090"
  revision 12

  livecheck do
    url :homepage
    regex(/href=.*?stfl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "9e57ebd3ab126b784b46969fa3c2baf49b4351183274d23f3075370e50735d48" => :big_sur
    sha256 "f38715316e6a6a3df8b25e6cd97c742ac2168d608ecdb2bcd7773e3e69117802" => :arm64_big_sur
    sha256 "ab1e06a1a46305fbcaadca0e490dd6584f149e704f1475e9d5243acebeaff7e1" => :catalina
    sha256 "0164c390d3ccad76079fe8b5af6e8cec440036e4e97dd91c5a1c86848832c0ab" => :mojave
  end

  depends_on "swig" => :build
  depends_on "python@3.9"
  depends_on "ruby"

  uses_from_macos "perl"

  def install
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"

    ENV.append "LDLIBS", "-liconv"
    ENV.append "LIBS", "-lncurses -liconv -lruby"

    %w[
      stfl.pc.in
      perl5/Makefile.PL
      ruby/Makefile.snippet
    ].each do |f|
      inreplace f, "ncursesw", "ncurses"
    end

    inreplace "stfl_internals.h", "ncursesw/ncurses.h", "ncurses.h"

    inreplace "Makefile" do |s|
      s.gsub! "ncursesw", "ncurses"
      s.gsub! "-Wl,-soname,$(SONAME)", "-Wl"
      s.gsub! "libstfl.so.$(VERSION)", "libstfl.$(VERSION).dylib"
      s.gsub! "libstfl.so", "libstfl.dylib"
    end

    xy = "3.8"
    python_config = Formula["python@3.9"].opt_libexec/"bin/python-config"

    inreplace "python/Makefile.snippet" do |s|
      # Install into the site-packages in the Cellar (so uninstall works)
      s.change_make_var! "PYTHON_SITEARCH", lib/"python#{xy}/site-packages"
      s.gsub! "lib-dynload/", ""
      s.gsub! "ncursesw", "ncurses"
      s.gsub! "gcc", "gcc -undefined dynamic_lookup #{`#{python_config} --cflags`.chomp}"
      s.gsub! "-lncurses", "-lncurses -liconv"
    end

    # Fails race condition of test:
    #   ImportError: dynamic module does not define init function (init_stfl)
    #   make: *** [python/_stfl.so] Error 1
    ENV.deparallelize

    system "make"

    inreplace "perl5/Makefile", "Network/Library", libexec/"lib/perl5"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <stfl.h>
      int main() {
        stfl_ipool * pool = stfl_ipool_create("utf-8");
        stfl_ipool_destroy(pool);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lstfl", "-o", "test"
    system "./test"
  end
end
