class LlvmAT38 < Formula
  desc "Next-gen compiler infrastructure"
  homepage "http://llvm.org/"

  stable do
    url "http://llvm.org/releases/3.8.1/llvm-3.8.1.src.tar.xz"
    sha256 "6e82ce4adb54ff3afc18053d6981b6aed1406751b8742582ed50f04b5ab475f9"

    resource "clang" do
      url "http://llvm.org/releases/3.8.1/cfe-3.8.1.src.tar.xz"
      sha256 "4cd3836dfb4b88b597e075341cae86d61c63ce3963e45c7fe6a8bf59bb382cdf"
    end

    resource "clang-tools-extra" do
      url "http://llvm.org/releases/3.8.1/clang-tools-extra-3.8.1.src.tar.xz"
      sha256 "664a5c60220de9c290bf2a5b03d902ab731a4f95fe73a00856175ead494ec396"
    end

    resource "polly" do
      url "http://llvm.org/releases/3.8.1/polly-3.8.1.src.tar.xz"
      sha256 "453c27e1581614bb3b6351bf5a2da2939563ea9d1de99c420f85ca8d87b928a2"
    end

    resource "lld" do
      url "http://llvm.org/releases/3.8.1/lld-3.8.1.src.tar.xz"
      sha256 "2bd9be8bb18d82f7f59e31ea33b4e58387dbdef0bc11d5c9fcd5ce9a4b16dc00"
    end

    resource "openmp" do
      url "http://llvm.org/releases/3.8.1/openmp-3.8.1.src.tar.xz"
      sha256 "68fcde6ef34e0275884a2de3450a31e931caf1d6fda8606ef14f89c4123617dc"
    end

    resource "libcxx" do
      url "http://llvm.org/releases/3.8.1/libcxx-3.8.1.src.tar.xz"
      sha256 "77d7f3784c88096d785bd705fa1bab7031ce184cd91ba8a7008abf55264eeecc"
    end

    if MacOS.version <= :snow_leopard
      resource "libcxxabi" do
        url "http://llvm.org/releases/3.8.1/libcxxabi-3.8.1.src.tar.xz"
        sha256 "e1b55f7be3fad746bdd3025f43e42d429fb6194aac5919c2be17c4a06314dae1"
      end
    end
  end

  bottle do
    rebuild 1
    sha256 "f84012d316cc335ebd93e4ac6fad1548eef54da23a8c690da5d517f1c78d72fb" => :sierra
    sha256 "889759dd33dcfccb62c9ddc89541e201afbd88572d165dc0bdf5d945e681d670" => :el_capitan
    sha256 "e49da061ea21b5490c916a224f4d7c5ec85e9e982bc0e377817cad3296b4e27e" => :yosemite
  end

  head do
    url "http://llvm.org/git/llvm.git", :branch => "release_38"

    resource "clang" do
      url "http://llvm.org/git/clang.git", :branch => "release_38"
    end

    resource "clang-tools-extra" do
      url "http://llvm.org/git/clang-tools-extra.git", :branch => "release_38"
    end

    resource "polly" do
      url "http://llvm.org/git/polly.git", :branch => "release_38"
    end

    resource "lld" do
      url "http://llvm.org/git/lld.git"
    end

    resource "openmp" do
      url "http://llvm.org/git/openmp.git", :branch => "release_38"
    end

    resource "libcxx" do
      url "http://llvm.org/git/libcxx.git", :branch => "release_38"
    end

    if MacOS.version <= :snow_leopard
      resource "libcxxabi" do
        url "http://llvm.org/git/libcxxabi.git", :branch => "release_38"
      end
    end
  end

  patch :DATA

  depends_on "gnu-sed" => :build
  depends_on "gmp"
  depends_on "libffi"

  # version suffix
  def ver
    "3.8"
  end

  # LLVM installs its own standard library which confuses stdlib checking.
  cxxstdlib_check :skip

  # Apple's libstdc++ is too old to build LLVM
  fails_with :gcc

  def install
    # One of llvm makefiles relies on gnu sed behavior to generate CMake modules correctly
    ENV.prepend_path "PATH", "#{Formula["gnu-sed"].opt_libexec}/gnubin"
    # Apple's libstdc++ is too old to build LLVM
    ENV.libcxx if ENV.compiler == :clang

    clang_buildpath = buildpath/"tools/clang"
    libcxx_buildpath = buildpath/"projects/libcxx"
    libcxxabi_buildpath = buildpath/"libcxxabi" # build failure if put in projects due to no Makefile

    clang_buildpath.install resource("clang")
    libcxx_buildpath.install resource("libcxx")
    (buildpath/"tools/polly").install resource("polly")
    (buildpath/"tools/clang/tools/extra").install resource("clang-tools-extra")
    (buildpath/"projects/openmp").install resource("openmp")

    ENV["REQUIRES_RTTI"] = "1"

    install_prefix = lib/"llvm-#{ver}"

    args = %W[
      --prefix=#{install_prefix}
      --enable-optimized
      --disable-bindings
      --with-gmp=#{Formula["gmp"].opt_prefix}
      --enable-shared
      --enable-targets=all
      --enable-libffi
    ]

    mktemp do
      system buildpath/"configure", *args
      system "make", "VERBOSE=1", "install"
      cd "tools/clang" do
        system "make", "install"
      end
    end

    if MacOS.version <= :snow_leopard
      libcxxabi_buildpath.install resource("libcxxabi")

      cd libcxxabi_buildpath/"lib" do
        # Set rpath to save user from setting DYLD_LIBRARY_PATH
        inreplace "buildit", "-install_name /usr/lib/libc++abi.dylib", "-install_name #{install_prefix}/usr/lib/libc++abi.dylib"

        ENV["CC"] = "#{install_prefix}/bin/clang"
        ENV["CXX"] = "#{install_prefix}/bin/clang++"
        ENV["TRIPLE"] = "*-apple-*"
        system "./buildit"
        (install_prefix/"usr/lib").install "libc++abi.dylib"
        cp libcxxabi_buildpath/"include/cxxabi.h", install_prefix/"lib/c++/v1"
      end

      # Snow Leopard make rules hardcode libc++ and libc++abi path.
      # Change to Cellar path here.
      inreplace "#{libcxx_buildpath}/lib/buildit" do |s|
        s.gsub! "-install_name /usr/lib/libc++.1.dylib", "-install_name #{install_prefix}/usr/lib/libc++.1.dylib"
        s.gsub! "-Wl,-reexport_library,/usr/lib/libc++abi.dylib", "-Wl,-reexport_library,#{install_prefix}/usr/lib/libc++abi.dylib"
      end

      # On Snow Leopard and older system libc++abi is not shipped but
      # needed here. It is hard to tweak environment settings to change
      # include path as libc++ uses a custom build script, so just
      # symlink the needed header here.
      ln_s libcxxabi_buildpath/"include/cxxabi.h", libcxx_buildpath/"include"
    end

    # Putting libcxx in projects only ensures that headers are installed.
    # Manually "make install" to actually install the shared libs.
    libcxx_make_args = [
      # Use the built clang for building
      "CC=#{install_prefix}/bin/clang",
      "CXX=#{install_prefix}/bin/clang++",
      # Properly set deployment target, which is needed for Snow Leopard
      "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}",
      # The following flags are needed so it can be installed correctly.
      "DSTROOT=#{install_prefix}",
      "SYMROOT=#{libcxx_buildpath}",
    ]

    system "make", "-C", libcxx_buildpath, "install", *libcxx_make_args

    (share/"clang/tools").install Dir["tools/clang/tools/scan-{build,view}"]
    inreplace share/"clang/tools/scan-build/bin/scan-build", "$RealBin/bin/clang", bin/"clang-#{ver}"
    bin.install_symlink share/"clang/tools/scan-build/bin/scan-build", share/"clang/tools/scan-view/bin/scan-view"
    man1.install_symlink share/"clang/tools/scan-build/man/scan-build.1"

    (lib/"python2.7/site-packages").install "bindings/python/llvm" => "llvm-#{ver}",
                                            clang_buildpath/"bindings/python/clang" => "clang-#{ver}"

    Dir.glob(install_prefix/"bin/*") do |exec_path|
      basename = File.basename(exec_path)
      bin.install_symlink exec_path => "#{basename}-#{ver}"
    end

    Dir.glob(install_prefix/"share/man/man1/*") do |manpage|
      basename = File.basename(manpage, ".1")
      man1.install_symlink manpage => "#{basename}-#{ver}.1"
    end
  end

  def caveats; <<-EOS.undent
    Extra tools are installed in #{opt_share}/clang-#{ver}

    To link to libc++, something like the following is required:
      CXX="clang++-#{ver} -stdlib=libc++"
      CXXFLAGS="$CXXFLAGS -nostdinc++ -I#{opt_lib}/llvm-#{ver}/include/c++/v1"
      LDFLAGS="$LDFLAGS -L#{opt_lib}/llvm-#{ver}/lib"
    EOS
  end

  test do
    # test for sed errors since some llvm makefiles assume that sed
    # understands '\n' which is true for gnu sed and not for bsd sed.
    assert_no_match /PATH\)n/, (lib/"llvm-3.8/share/llvm/cmake/LLVMConfig.cmake").read
    system "#{bin}/llvm-config-#{ver}", "--version"
  end
end

__END__
diff --git a/Makefile.rules b/Makefile.rules
index ebebc0a..b0bb378 100644
--- a/Makefile.rules
+++ b/Makefile.rules
@@ -600,7 +600,12 @@ ifneq ($(HOST_OS), $(filter $(HOST_OS), Cygwin MingW))
 ifneq ($(HOST_OS),Darwin)
   LD.Flags += $(RPATH) -Wl,'$$ORIGIN'
 else
-  LD.Flags += -Wl,-install_name  -Wl,"@rpath/lib$(LIBRARYNAME)$(SHLIBEXT)"
+  LD.Flags += -Wl,-install_name
+  ifdef LOADABLE_MODULE
+    LD.Flags += -Wl,"$(PROJ_libdir)/$(LIBRARYNAME)$(SHLIBEXT)"
+  else
+    LD.Flags += -Wl,"$(PROJ_libdir)/$(SharedPrefix)$(LIBRARYNAME)$(SHLIBEXT)"
+  endif
 endif
 endif
 endif
diff --git a/configure b/configure
index c94fb13..8d61650 100755
--- a/configure
+++ b/configure
@@ -1,6 +1,6 @@
 #! /bin/sh
 # Guess values for system-dependent variables and create Makefiles.
-# Generated by GNU Autoconf 2.60 for LLVM 3.8.0.
+# Generated by GNU Autoconf 2.60 for LLVM 3.8.1.
 #
 # Report bugs to <http://llvm.org/bugs/>.
 #
@@ -561,8 +561,8 @@ SHELL=${CONFIG_SHELL-/bin/sh}
 # Identity of this package.
 PACKAGE_NAME='LLVM'
 PACKAGE_TARNAME='llvm'
-PACKAGE_VERSION='3.8.0'
-PACKAGE_STRING='LLVM 3.8.0'
+PACKAGE_VERSION='3.8.1'
+PACKAGE_STRING='LLVM 3.8.1'
 PACKAGE_BUGREPORT='http://llvm.org/bugs/'

 ac_unique_file="lib/IR/Module.cpp"
@@ -1334,7 +1334,7 @@ if test "$ac_init_help" = "long"; then
   # Omit some internal or obsolete options to make the list less imposing.
   # This message is too long to be a string in the A/UX 3.1 sh.
   cat <<_ACEOF
-\`configure' configures LLVM 3.8.0 to adapt to many kinds of systems.
+\`configure' configures LLVM 3.8.1 to adapt to many kinds of systems.

 Usage: $0 [OPTION]... [VAR=VALUE]...

@@ -1400,7 +1400,7 @@ fi

 if test -n "$ac_init_help"; then
   case $ac_init_help in
-     short | recursive ) echo "Configuration of LLVM 3.8.0:";;
+     short | recursive ) echo "Configuration of LLVM 3.8.1:";;
    esac
   cat <<\_ACEOF

@@ -1584,7 +1584,7 @@ fi
 test -n "$ac_init_help" && exit $ac_status
 if $ac_init_version; then
   cat <<\_ACEOF
-LLVM configure 3.8.0
+LLVM configure 3.8.1
 generated by GNU Autoconf 2.60

 Copyright (C) 1992, 1993, 1994, 1995, 1996, 1998, 1999, 2000, 2001,
@@ -1600,7 +1600,7 @@ cat >config.log <<_ACEOF
 This file contains any messages produced by compilers while
 running configure, to aid debugging if configure makes a mistake.

-It was created by LLVM $as_me 3.8.0, which was
+It was created by LLVM $as_me 3.8.1, which was
 generated by GNU Autoconf 2.60.  Invocation command line was

   $ $0 $@
@@ -1956,7 +1956,7 @@ ac_compiler_gnu=$ac_cv_c_compiler_gnu

 LLVM_VERSION_MAJOR=3
 LLVM_VERSION_MINOR=8
-LLVM_VERSION_PATCH=0
+LLVM_VERSION_PATCH=1
 LLVM_VERSION_SUFFIX=


@@ -18279,7 +18279,7 @@ exec 6>&1
 # report actual input values of CONFIG_FILES etc. instead of their
 # values after options handling.
 ac_log="
-This file was extended by LLVM $as_me 3.8.0, which was
+This file was extended by LLVM $as_me 3.8.1, which was
 generated by GNU Autoconf 2.60.  Invocation command line was

   CONFIG_FILES    = $CONFIG_FILES
@@ -18332,7 +18332,7 @@ Report bugs to <bug-autoconf@gnu.org>."
 _ACEOF
 cat >>$CONFIG_STATUS <<_ACEOF
 ac_cs_version="\\
-LLVM config.status 3.8.0
+LLVM config.status 3.8.1
 configured by $0, generated by GNU Autoconf 2.60,
   with options \\"`echo "$ac_configure_args" | sed 's/^ //; s/[\\""\`\$]/\\\\&/g'`\\"
