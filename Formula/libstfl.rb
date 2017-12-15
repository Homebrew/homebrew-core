class Libstfl < Formula
  desc "Library implementing a curses-based widget set for terminals"
  homepage "http://www.clifford.at/stfl/"
  url "http://www.clifford.at/stfl/stfl-0.24.tar.gz"
  sha256 "d4a7aa181a475aaf8a8914a8ccb2a7ff28919d4c8c0f8a061e17a0c36869c090"
  revision 4

  bottle do
    cellar :any
    sha256 "8929e1948656e633b34cec6b4712e658231225c570e33420e0cad40423befb06" => :high_sierra
    sha256 "d900eaec7e6a5e557d373f635316e7c1b42ced88c97be72fcf9ea09e928010f5" => :sierra
    sha256 "6de789108cf1be69962b89611f143aa124fed043e5dadf8e328fc730ecc8b1b5" => :el_capitan
  end

  option "without-perl", "Build without Perl support"
  option "without-python", "Build without Python 2 support"

  depends_on :ruby => ["1.8", :recommended]
  depends_on "swig" => :build if build.with?("python") || build.with?("ruby") || build.with?("perl")

  def install
    ENV.append "LDLIBS", "-liconv"
    ENV.append "LIBS", "-lncurses -liconv"
    ENV.append "LIBS", "-lruby" if build.with? "ruby"

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
      s.gsub! "include perl5/Makefile.snippet", "" if build.without? "perl"
      s.gsub! "include python/Makefile.snippet", "" if build.without? "python"
      s.gsub! "include ruby/Makefile.snippet", "" if build.without? "ruby"
    end

    if build.with? "python"
      inreplace "python/Makefile.snippet" do |s|
        # Install into the site-packages in the Cellar (so uninstall works)
        s.change_make_var! "PYTHON_SITEARCH", lib/"python2.7/site-packages"
        s.gsub! "lib-dynload/", ""
        s.gsub! "ncursesw", "ncurses"
        s.gsub! "gcc", "gcc -undefined dynamic_lookup #{`python-config --cflags`.chomp}"
        s.gsub! "-lncurses", "-lncurses -liconv"
      end

      # Fails race condition of test:
      #   ImportError: dynamic module does not define init function (init_stfl)
      #   make: *** [python/_stfl.so] Error 1
      ENV.deparallelize
    end

    system "make"

    inreplace "perl5/Makefile", "Network/Library", libexec/"lib/perl5" if build.with? "perl"

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
