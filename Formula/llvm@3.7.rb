class LlvmAT37 < Formula
  desc "Next-gen compiler infrastructure"
  homepage "http://llvm.org/"

  stable do
    url "http://llvm.org/releases/3.7.1/llvm-3.7.1.src.tar.xz"
    sha256 "be7794ed0cec42d6c682ca8e3517535b54555a3defabec83554dbc74db545ad5"

    resource "clang" do
      url "http://llvm.org/releases/3.7.1/cfe-3.7.1.src.tar.xz"
      sha256 "56e2164c7c2a1772d5ed2a3e57485ff73ff06c97dff12edbeea1acc4412b0674"
    end

    resource "clang-tools-extra" do
      url "http://llvm.org/releases/3.7.1/clang-tools-extra-3.7.1.src.tar.xz"
      sha256 "4a91edaccad1ce984c7c49a4a87db186b7f7b21267b2b03bcf4bd7820715bc6b"
    end

    resource "polly" do
      url "http://llvm.org/releases/3.7.1/polly-3.7.1.src.tar.xz"
      sha256 "ce9273ad315e1904fd35dc64ac4375fd592f3c296252ab1d163b9ff593ec3542"
    end

    resource "libcxx" do
      url "http://llvm.org/releases/3.7.1/libcxx-3.7.1.src.tar.xz"
      sha256 "357fbd4288ce99733ba06ae2bec6f503413d258aeebaab8b6a791201e6f7f144"
    end

    if MacOS.version <= :snow_leopard
      resource "libcxxabi" do
        url "http://llvm.org/releases/3.7.1/libcxxabi-3.7.1.src.tar.xz"
        sha256 "a47faaed90f577da8ca3b5f044be9458d354a53fab03003a44085a912b73ab2a"
      end
    end
  end

  bottle do
    rebuild 1
    sha256 "086d8f2aee762f69511d25f704579828428dafb37f308ade14cbb2cec106046e" => :sierra
    sha256 "f61418bf5315eb0b346c23b2dbb81f9d62cdb00f173b3b5eee9e25ac96dbe796" => :el_capitan
    sha256 "e006a9164903c96932e43c259cbd909f1316f4172a59e2057f28108e5aa87913" => :yosemite
  end

  head do
    url "http://llvm.org/git/llvm.git", :branch => "release_37"

    resource "clang" do
      url "http://llvm.org/git/clang.git", :branch => "release_37"
    end

    resource "clang-tools-extra" do
      url "http://llvm.org/git/clang-tools-extra.git", :branch => "release_37"
    end

    resource "polly" do
      url "http://llvm.org/git/polly.git", :branch => "release_37"
    end

    resource "libcxx" do
      url "http://llvm.org/git/libcxx.git", :branch => "release_37"
    end

    if MacOS.version <= :snow_leopard
      resource "libcxxabi" do
        url "http://llvm.org/git/libcxxabi.git", :branch => "release_37"
      end
    end
  end

  patch :DATA

  depends_on "gnu-sed" => :build
  depends_on "gmp"
  depends_on "libffi"

  # version suffix
  def ver
    "3.7"
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
      system "make", "VERBOSE=1"
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

    if MacOS.version >= :el_capitan
      inreplace "#{libcxx_buildpath}/include/string",
        "basic_string<_CharT, _Traits, _Allocator>::basic_string(const allocator_type& __a)",
        "basic_string<_CharT, _Traits, _Allocator>::basic_string(const allocator_type& __a) noexcept(is_nothrow_copy_constructible<allocator_type>::value)"
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

    (share/"clang-#{ver}/tools").install Dir["tools/clang/tools/scan-{build,view}"]
    inreplace share/"clang-#{ver}/tools/scan-build/scan-build", "$RealBin/bin/clang", install_prefix/"bin/clang"
    ln_s share/"clang-#{ver}/tools/scan-build/scan-build", install_prefix/"bin"
    ln_s share/"clang-#{ver}/tools/scan-view/scan-view", install_prefix/"bin"
    (install_prefix/"share/man/man1").install share/"clang-#{ver}/tools/scan-build/scan-build.1"

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
    assert_no_match /PATH\)n/, (lib/"llvm-3.7/share/llvm/cmake/LLVMConfig.cmake").read
    system "#{bin}/llvm-config-#{ver}", "--version"
  end
end

__END__
diff --git a/Makefile.rules b/Makefile.rules
index ebebc0a..b0bb378 100644
--- a/Makefile.rules
+++ b/Makefile.rules
@@ -599,7 +599,12 @@ ifneq ($(HOST_OS), $(filter $(HOST_OS), Cygwin MingW))
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
