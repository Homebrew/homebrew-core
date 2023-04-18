class Libstfl < Formula
  desc "Library implementing a curses-based widget set for terminals"
  homepage "http://www.clifford.at/stfl/"
  url "http://www.clifford.at/stfl/stfl-0.24.tar.gz"
  sha256 "d4a7aa181a475aaf8a8914a8ccb2a7ff28919d4c8c0f8a061e17a0c36869c090"
  license "LGPL-3.0-or-later"
  revision 13

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "0b1fd6b1765f50e9761dbdeac4f600cdb93be3e3a43e50c26fd4f5fa6ba334ea"
    sha256 cellar: :any,                 big_sur:       "76ddf39817cb57cd96f41b932f9f26cbe2d351ef5d8bbb3a28fe400bab623326"
    sha256 cellar: :any,                 catalina:      "f1ce2014b0b91e3092e224caf8d7438b4c2f3dfe390d47d0455515e58b9cc260"
    sha256 cellar: :any,                 mojave:        "ad965ea1d3ccce63a01d2951182a5f9a87c81a08d72ff99a509e5977d68c49a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "877cdb8227cbb5322b392b55cce951a46f6f5af2f8545998e72fb9daaf7b2117"
  end

  disable! date: "2022-11-29", because: :repo_removed

  depends_on "python@3.9" => [:build, :test]
  depends_on "swig" => :build
  depends_on "ruby"

  uses_from_macos "perl" => [:build, :test]
  uses_from_macos "ncurses"

  # Fix Python logic to be compatible with Python 3
  # Fix Ruby logic to use Homebrew Ruby's sitedir
  patch :DATA

  def install
    if OS.mac?
      ENV.append "LDLIBS", "-liconv"
      ENV.append "LIBS", "-lncurses -lruby -liconv"

      inreplace "stfl_internals.h", "ncursesw/ncurses.h", "ncurses.h"
      inreplace %w[stfl.pc.in ruby/Makefile.snippet], "ncursesw", "ncurses"

      inreplace "Makefile" do |s|
        s.gsub! "ncursesw", "ncurses"
        s.gsub! "-Wl,-soname,$(SONAME)", "-Wl"
        s.gsub! "libstfl.so.$(VERSION)", "libstfl.$(VERSION).dylib"
        s.gsub! "libstfl.so", "libstfl.dylib"
      end

      # Fix ncurses linkage for Perl bundle
      inreplace "perl5/Makefile.PL", "-lncursesw", "-L#{MacOS.sdk_path}/usr/lib -lncurses"
    else
      ENV.append "LIBS", "-lncursesw -lruby"
      inreplace "Makefile", "$(LDLIBS) $^", "$^ $(LDLIBS)"
    end

    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"
    xy = Language::Python.major_minor_version "python3"
    py_cflags = Utils.safe_popen_read("python-config", "--cflags").chomp

    inreplace "python/Makefile.snippet" do |s|
      # Install into the site-packages in the Cellar (so uninstall works)
      s.change_make_var! "PYTHON_SITEARCH", lib/"python#{xy}/site-packages"
      s.gsub! "gcc", "gcc #{py_cflags}"

      if OS.mac?
        s.gsub! "-lncursesw", "-lncurses -liconv"
        s.gsub! "gcc", "gcc -undefined dynamic_lookup"
      end
    end

    inreplace "perl5/Makefile.snippet", "perl Makefile.PL", "perl Makefile.PL INSTALL_BASE=#{libexec}"

    # Fails race condition of test:
    #   ImportError: dynamic module does not define init function (init_stfl)
    #   make: *** [python/_stfl.so] Error 1
    ENV.deparallelize
    system "make"
    system "make", "install", "prefix=#{prefix}"

    lib.install_symlink "libstfl.so.#{version}" => "libstfl.so.#{version.major}" if OS.linux?
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

    system Formula["python@3.9"].opt_bin/"python3", "-c", "import stfl"
    system Formula["ruby"].opt_bin/"ruby", "-e", "require 'stfl'"

    with_env(PERL5LIB: libexec/"lib/perl5") do
      system "perl", "-e", "use stfl"
    end
  end
end

__END__
--- a/Makefile.cfg
+++ b/Makefile.cfg
@@ -40,7 +40,7 @@ else
 FOUND_PERL5 = 0
 endif

-ifneq ($(shell python -c 'print 1' 2>/dev/null),)
+ifneq ($(shell python -c 'print(1)' 2>/dev/null),)
 FOUND_PYTHON = 1
 else
 FOUND_PYTHON = 0
--- a/python/Makefile.snippet
+++ b/python/Makefile.snippet
@@ -33,8 +33,6 @@ python/_stfl.so python/stfl.py python/stfl.pyc: libstfl.a stfl.h python/stfl.i s

 install_python: python/_stfl.so python/stfl.py python/stfl.pyc
 	mkdir -p $(DESTDIR)$(PYTHON_SITEARCH)/
-	mkdir -p $(DESTDIR)$(PYTHON_SITEARCH)/lib-dynload/
-	cp python/_stfl.so $(DESTDIR)$(PYTHON_SITEARCH)/lib-dynload/
-	cp python/stfl.pyc $(DESTDIR)$(PYTHON_SITEARCH)/
+	cp python/_stfl.so $(DESTDIR)$(PYTHON_SITEARCH)/
 	cp python/stfl.py $(DESTDIR)$(PYTHON_SITEARCH)/

--- a/ruby/Makefile.snippet
+++ b/ruby/Makefile.snippet
@@ -25,9 +25,9 @@ install: install_ruby

 ruby/build_ok: libstfl.a stfl.h ruby/stfl.i swig/*.i
 	cd ruby && swig -ruby stfl.i && ruby extconf.rb
-	$(MAKE) -C ruby clean && $(MAKE) -C ruby LIBS+="../libstfl.a -lncursesw" CFLAGS+="-pthread -I.." DLDFLAGS+="-pthread" DESTDIR=$(DESTDIR) prefix=$(prefix) sitedir=$(prefix)/$(libdir)/ruby
+	$(MAKE) -C ruby clean && $(MAKE) -C ruby LIBS+="../libstfl.a -lncursesw" CFLAGS+="-pthread -I.." DLDFLAGS+="-pthread" DESTDIR=$(DESTDIR) prefix=$(prefix) sitedir=$(prefix)/$(libdir)/ruby/site_ruby
 	touch ruby/build_ok

 install_ruby: ruby/build_ok
-	$(MAKE) -C ruby DESTDIR=$(DESTDIR) prefix=$(prefix) sitedir='$(DESTDIR)$(prefix)/$(libdir)/ruby' install
+	$(MAKE) -C ruby DESTDIR=$(DESTDIR) prefix=$(prefix) sitedir='$(DESTDIR)$(prefix)/$(libdir)/ruby/site_ruby' install
