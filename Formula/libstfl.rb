class Libstfl < Formula
  desc "Library implementing a curses-based widget set for terminals"
  homepage "http://www.clifford.at/stfl/"
  url "http://www.clifford.at/stfl/stfl-0.24.tar.gz"
  sha256 "d4a7aa181a475aaf8a8914a8ccb2a7ff28919d4c8c0f8a061e17a0c36869c090"
  revision 5

  bottle do
    cellar :any
    sha256 "a975bf5ce425a98a822baf0cd3fc4adbe50fa19ced10eba54b3fe8400326e56e" => :high_sierra
    sha256 "f1ae9d6ff0abb4e4046f71d074722824752ffa5ec33a710903af47b4531bc237" => :sierra
    sha256 "8f1c6903c6362792ba17df75ad88f8ad11fd40abe19efd16bea7b89e2208bc9d" => :el_capitan
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
