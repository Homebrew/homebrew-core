class Node < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v7.5.0/node-v7.5.0.tar.xz"
  sha256 "f99ee74647fe223eb03f2dd1dc6acdc14d9a881621376c848236c8d2ac8afd03"
  head "https://github.com/nodejs/node.git"

  bottle do
    sha256 "421071a942e3f2ab22dd304ccc78d88b5093eb51c805731791ff55dd5bf7fc78" => :sierra
    sha256 "363eb6dbb4c5534e69de909eb11c9a73255f33319a8d01b5cb550d37e9613124" => :el_capitan
    sha256 "59525a77b38e553d0a7b6faedeaa996b296aaae30394cb0c7a132d46eeea67f4" => :yosemite
  end

  option "with-debug", "Build with debugger hooks"
  option "with-openssl", "Build against Homebrew's OpenSSL instead of the bundled OpenSSL"
  option "without-npm", "npm will not be installed"
  option "without-completion", "npm bash completion will not be installed"
  option "without-icu4c", "Build with small-icu (English only) instead of system-icu (all locales)"

  deprecated_option "enable-debug" => "with-debug"

  depends_on :python => :build if MacOS.version <= :snow_leopard
  depends_on "pkg-config" => :build
  depends_on "icu4c" => :recommended
  depends_on "openssl" => :optional

  # Per upstream - "Need g++ 4.8 or clang++ 3.4".
  fails_with :clang if MacOS.version <= :snow_leopard
  fails_with :gcc_4_0
  fails_with :gcc
  ("4.3".."4.7").each do |n|
    fails_with :gcc => n
  end

  # We track major/minor from upstream Node releases.
  # We will accept *important* npm patch releases when necessary.
  # https://github.com/Homebrew/homebrew/pull/46098#issuecomment-157802319
  resource "npm" do
    url "https://registry.npmjs.org/npm/-/npm-4.1.2.tgz"
    sha256 "87f2c95f98ac53d14d9e2c506f8ecfe1d891cd7c970450c74bf0daff24d65cfd"
  end

  # Fix run-time failure "Symbol not found: _clock_gettime"
  # Upstream issue "7.5.0 clock_gettime runtime failure built with macOS 10.11
  # and Xcode 8.x"
  # Reported 1 Feb 2017 https://github.com/nodejs/node/issues/11104
  if MacOS.version == :el_capitan && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
    patch :DATA
  end

  def install
    # Never install the bundled "npm", always prefer our
    # installation from tarball for better packaging control.
    args = %W[--prefix=#{prefix} --without-npm]
    args << "--debug" if build.with? "debug"
    args << "--with-intl=system-icu" if build.with? "icu4c"
    args << "--shared-openssl" if build.with? "openssl"
    args << "--tag=head" if build.head?

    system "./configure", *args
    system "make", "install"

    if build.with? "npm"
      resource("npm").stage buildpath/"npm_install"

      # make sure npm can find node
      ENV.prepend_path "PATH", bin
      # set log level temporarily for npm's `make install`
      ENV["NPM_CONFIG_LOGLEVEL"] = "verbose"
      # unset prefix temporarily for npm's `make install`
      ENV.delete "NPM_CONFIG_PREFIX"

      cd buildpath/"npm_install" do
        system "./configure", "--prefix=#{libexec}/npm"
        system "make", "install"
        # `package.json` has relative paths to the npm_install directory.
        # This copies back over the vanilla `package.json` that is expected.
        # https://github.com/Homebrew/homebrew/issues/46131#issuecomment-157845008
        cp buildpath/"npm_install/package.json", libexec/"npm/lib/node_modules/npm"
        # Remove manpage symlinks from the buildpath, they are breaking bottle
        # creation. The real manpages are living in libexec/npm/lib/node_modules/npm/man/
        # https://github.com/Homebrew/homebrew/pull/47081#issuecomment-165280470
        rm_rf libexec/"npm/share/"
      end

      if build.with? "completion"
        bash_completion.install \
          buildpath/"npm_install/lib/utils/completion.sh" => "npm"
      end
    end
  end

  def post_install
    return if build.without? "npm"

    node_modules = HOMEBREW_PREFIX/"lib/node_modules"
    node_modules.mkpath
    npm_exec = node_modules/"npm/bin/npm-cli.js"
    # Kill npm but preserve all other modules across node updates/upgrades.
    rm_rf node_modules/"npm"

    cp_r libexec/"npm/lib/node_modules/npm", node_modules
    # This symlink doesn't hop into homebrew_prefix/bin automatically so
    # remove it and make our own. This is a small consequence of our bottle
    # npm make install workaround. All other installs **do** symlink to
    # homebrew_prefix/bin correctly. We ln rather than cp this because doing
    # so mimics npm's normal install.
    ln_sf npm_exec, "#{HOMEBREW_PREFIX}/bin/npm"

    # Let's do the manpage dance. It's just a jump to the left.
    # And then a step to the right, with your hand on rm_f.
    ["man1", "man3", "man5", "man7"].each do |man|
      # Dirs must exist first: https://github.com/Homebrew/homebrew/issues/35969
      mkdir_p HOMEBREW_PREFIX/"share/man/#{man}"
      rm_f Dir[HOMEBREW_PREFIX/"share/man/#{man}/{npm.,npm-,npmrc.,package.json.}*"]
      ln_sf Dir[libexec/"npm/lib/node_modules/npm/man/#{man}/{npm,package.json}*"], HOMEBREW_PREFIX/"share/man/#{man}"
    end

    npm_root = node_modules/"npm"
    npmrc = npm_root/"npmrc"
    npmrc.atomic_write("prefix = #{HOMEBREW_PREFIX}\n")
  end

  def caveats
    s = ""

    if build.without? "npm"
      s += <<-EOS.undent
        Homebrew has NOT installed npm. If you later install it, you should supplement
        your NODE_PATH with the npm module folder:
          #{HOMEBREW_PREFIX}/lib/node_modules
      EOS
    end

    if build.without? "full-icu"
      s += <<-EOS.undent
        Please note by default only English locale support is provided. If you need
        full locale support you should either rebuild with full icu:
          `brew reinstall node --with-full-icu`
        or add full icu data at runtime following:
          https://github.com/nodejs/node/wiki/Intl#using-and-customizing-the-small-icu-build
      EOS
    end

    s
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = shell_output("#{bin}/node #{path}").strip
    assert_equal "hello", output
    output = shell_output("#{bin}/node -e 'console.log(new Intl.NumberFormat(\"en-EN\").format(1234.56))'").strip
    assert_equal "1,234.56", output
    if build.with? "full-icu"
      output = shell_output("#{bin}/node -e 'console.log(new Intl.NumberFormat(\"de-DE\").format(1234.56))'").strip
      assert_equal "1.234,56", output
    end

    if build.with? "npm"
      # make sure npm can find node
      ENV.prepend_path "PATH", opt_bin
      ENV.delete "NVM_NODEJS_ORG_MIRROR"
      assert_equal which("node"), opt_bin/"node"
      assert (HOMEBREW_PREFIX/"bin/npm").exist?, "npm must exist"
      assert (HOMEBREW_PREFIX/"bin/npm").executable?, "npm must be executable"
      system "#{HOMEBREW_PREFIX}/bin/npm", "--verbose", "install", "npm@latest"
      system "#{HOMEBREW_PREFIX}/bin/npm", "--verbose", "install", "bignum" unless head?
    end
  end
end

__END__
diff --git a/deps/openssl/openssl/apps/apps.c b/deps/openssl/openssl/apps/apps.c
index c487bd9..9456e47 100644
--- a/deps/openssl/openssl/apps/apps.c
+++ b/deps/openssl/openssl/apps/apps.c
@@ -150,6 +150,10 @@ static int WIN32_rename(const char *from, const char *to);
 # define rename(from,to) WIN32_rename((from),(to))
 #endif
 
+#ifdef __APPLE__
+#include <AvailabilityMacros.h>
+#endif
+
 typedef struct {
     const char *name;
     unsigned long flag;
@@ -3041,7 +3045,7 @@ double app_tminterval(int stop, int usertime)
 double app_tminterval(int stop, int usertime)
 {
     double ret = 0;
-# ifdef CLOCK_REALTIME
+# if (defined(__APPLE__) && MAC_OS_X_VERSION_MIN_REQUIRED >= 101200) || (!defined(__APPLE__) && defined(CLOCK_REALTIME))
     static struct timespec tmstart;
     struct timespec now;
 # else
@@ -3055,7 +3059,13 @@ double app_tminterval(int stop, int usertime)
                    "this program on idle system.\n");
         warning = 0;
     }
-# ifdef CLOCK_REALTIME
+# if (defined(__APPLE__) && MAC_OS_X_VERSION_MIN_REQUIRED >= 101200) || (!defined(__APPLE__) && defined(CLOCK_REALTIME))
+    clock_gettime(CLOCK_REALTIME, &now);
+    if (stop == TM_START)
+        tmstart = now;
+    else
+        ret = ((now.tv_sec + now.tv_nsec * 1e-9)
+               - (tmstart.tv_sec + tmstart.tv_nsec * 1e-9));
     clock_gettime(CLOCK_REALTIME, &now);
     if (stop == TM_START)
         tmstart = now;
diff --git a/deps/uv/src/unix/darwin.c b/deps/uv/src/unix/darwin.c
index b1ffbc3..23e91db 100644
--- a/deps/uv/src/unix/darwin.c
+++ b/deps/uv/src/unix/darwin.c
@@ -36,6 +36,7 @@
 #include <sys/sysctl.h>
 #include <time.h>
 #include <unistd.h>  /* sysconf */
+#include <AvailabilityMacros.h>
 
 #undef NANOSEC
 #define NANOSEC ((uint64_t) 1e9)
@@ -57,7 +58,7 @@ void uv__platform_loop_delete(uv_loop_t* loop) {
 
 
 uint64_t uv__hrtime(uv_clocktype_t type) {
-#ifdef MAC_OS_X_VERSION_10_12
+#if MAC_OS_X_VERSION_MIN_REQUIRED >= 101200
   struct timespec ts;
   clock_gettime(CLOCK_MONOTONIC, &ts);
   return (((uint64_t) ts.tv_sec) * NANOSEC + ts.tv_nsec);
