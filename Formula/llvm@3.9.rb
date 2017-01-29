class LlvmAT39 < Formula
  desc "Next-gen compiler infrastructure"
  homepage "http://llvm.org/"

  stable do
    url "http://releases.llvm.org/3.9.1/llvm-3.9.1.src.tar.xz"
    sha256 "1fd90354b9cf19232e8f168faf2220e79be555df3aa743242700879e8fd329ee"

    resource "clang" do
      url "http://releases.llvm.org/3.9.1/cfe-3.9.1.src.tar.xz"
      sha256 "e6c4cebb96dee827fa0470af313dff265af391cb6da8d429842ef208c8f25e63"
    end

    resource "clang-tools-extra" do
      url "http://releases.llvm.org/3.9.1/clang-tools-extra-3.9.1.src.tar.xz"
      sha256 "29a5b65bdeff7767782d4427c7c64d54c3a8684bc6b217b74a70e575e4813635"
    end

    resource "compiler-rt" do
      url "http://releases.llvm.org/3.9.1/compiler-rt-3.9.1.src.tar.xz"
      sha256 "d30967b1a5fa51a2503474aacc913e69fd05ae862d37bf310088955bdb13ec99"
    end

    resource "polly" do
      url "http://releases.llvm.org/3.9.1/polly-3.9.1.src.tar.xz"
      sha256 "9ba5e61fc7bf8c7435f64e2629e0810c9b1d1b03aa5b5605b780d0e177b4cb46"
    end

    resource "lld" do
      url "http://releases.llvm.org/3.9.1/lld-3.9.1.src.tar.xz"
      sha256 "48e128fabb2ddaee64ecb8935f7ac315b6e68106bc48aeaf655d179c65d87f34"
    end

    resource "openmp" do
      url "http://releases.llvm.org/3.9.1/openmp-3.9.1.src.tar.xz"
      sha256 "d23b324e422c0d5f3d64bae5f550ff1132c37a070e43c7ca93991676c86c7766"
    end

    resource "libcxx" do
      url "http://releases.llvm.org/3.9.1/libcxx-3.9.1.src.tar.xz"
      sha256 "25e615e428f60e651ed09ffd79e563864e3f4bc69a9e93ee41505c419d1a7461"
    end

    resource "libunwind" do
      url "http://releases.llvm.org/3.9.1/libunwind-3.9.1.src.tar.xz"
      sha256 "0b0bc73264d7ab77d384f8a7498729e3c4da8ffee00e1c85ad02a2f85e91f0e6"
    end
  end

  bottle do
  end

  head do
    url "http://llvm.org/git/llvm.git", :branch => "release_39"

    resource "clang" do
      url "http://llvm.org/git/clang.git", :branch => "release_39"
    end

    resource "clang-tools-extra" do
      url "http://llvm.org/git/clang-tools-extra.git", :branch => "release_39"
    end

    resource "compiler-rt" do
      url "http://llvm.org/git/compiler-rt.git", :branch => "release_39"
    end

    resource "polly" do
      url "http://llvm.org/git/polly.git", :branch => "release_39"
    end

    resource "lld" do
      url "http://llvm.org/git/lld.git", :branch => "release_39"
    end

    resource "openmp" do
      url "http://llvm.org/git/openmp.git", :branch => "release_39"
    end

    resource "libcxx" do
      url "http://llvm.org/git/libcxx.git", :branch => "release_39"
    end

    resource "libunwind" do
      url "http://llvm.org/git/libunwind.git", :branceh => "release_39"
    end
  end

  # http://releases.llvm.org/3.9.1/docs/GettingStarted.html#requirements
  depends_on "libffi"
  depends_on "cmake" => :build

  # requires gcc >= 4.7
  fails_with :gcc_4_0
  fails_with :gcc
  ("4.3".."4.6").each do |n|
    fails_with :gcc => n
  end

  # version suffix
  def ver
    "3.9"
  end

  # http://releases.llvm.org/3.9.1/docs/CMake.html
  def install
    # Apple's libstdc++ is too old to build LLVM
    ENV.libcxx if ENV.compiler == :clang

    # compiler-rt has some iOS simulator features that require i386 symbols. I'm
    # assuming the rest of clang also needs support for 32-bit compilation to
    # work correctly, but if not, perhaps universal binaries could be limited to
    # compiler-rt. LLVM makes this somewhat easier because compiler-rt can
    # almost be treated as an entirely different build from LLVM.
    ENV.permit_arch_flags

    clang_buildpath  = buildpath/"tools/clang"
    libcxx_buildpath = buildpath/"projects/libcxx"

    clang_buildpath.install resource("clang")
    libcxx_buildpath.install resource("libcxx")
    (buildpath/"tools/lld").install resource("lld")
    (buildpath/"tools/polly").install resource("polly")
    (buildpath/"tools/clang/tools/extra").install resource("clang-tools-extra")
    (buildpath/"projects/openmp").install resource("openmp")
    (buildpath/"projects/libcxx").install resource("libcxx")
    (buildpath/"projects/libunwind").install resource("libunwind")
    (buildpath/"projects/compiler-rt").install resource("compiler-rt")

    install_prefix = lib/"llvm-#{ver}"

    args = %W[
      -DCMAKE_INSTALL_PREFIX=#{install_prefix}
      -DCMAKE_BUILD_TYPE=Release
      -DLLVM_OPTIMIZED_TABLEGEN=ON
      -DLLVM_INCLUDE_DOCS=OFF
      -DLLVM_ENABLE_RTTI=ON
      -DLLVM_ENABLE_EH=ON
      -DLLVM_INSTALL_UTILS=ON
      -DWITH_POLLY=ON
      -DLINK_POLLY_INTO_TOOLS=ON
      -DLLVM_TARGETS_TO_BUILD=all
      -DLIBOMP_ARCH=x86_64
      -DLLVM_BUILD_LLVM_DYLIB=ON
      -DLLVM_ENABLE_LIBCXX=ON
      -DLLVM_ENABLE_FFI=ON
      -DFFI_INCLUDE_DIR=#{Formula["libffi"].opt_lib}/libffi-#{Formula["libffi"].version}/include
      -DFFI_LIBRARY_DIR=#{Formula["libffi"].opt_lib}
    ]

    mktemp do
      system "cmake", buildpath, *(std_cmake_args + args)
      system "cmake", "--build", "."
      system "cmake", "--build", ".", "--target", "install"
    end

    (share/"clang-#{ver}/tools").install Dir["tools/clang/tools/scan-{build,view}"]
    inreplace share/"clang-#{ver}/tools/scan-build/bin/scan-build", "$RealBin/bin/clang", install_prefix/"bin/clang"
    (install_prefix/"bin").install_symlink share/"clang-#{ver}/tools/scan-view/bin/scan-view"
    (install_prefix/"bin").install_symlink share/"clang-#{ver}/tools/scan-build/bin/scan-build"
    (install_prefix/"share/man/man1").install_symlink share/"clang-#{ver}/tools/scan-build/scan-build.1"

    (lib/"python2.7/site-packages").install "bindings/python/llvm" => "llvm-#{ver}",
                                            clang_buildpath/"bindings/python/clang" => "clang-#{ver}"

    # replace the existing "clang -> clang-3.9" symlink
    rm install_prefix/"bin/clang"
    mv install_prefix/"bin/clang-#{ver}", install_prefix/"bin/clang"

    # These versioned .dylib symlinks are missing for some reason
    # Note that we use relative symlinks
    ln_s "libLLVM.dylib", install_prefix/"lib/libLLVM-3.9.dylib"
    ln_s "libLLVM.dylib", install_prefix/"lib/libLLVM-3.9.1.dylib"

    # Fix this LC_LOAD_DYLIB entry in libLLVM.dylib
    system "install_name_tool", "-change", "@rpath/libLTO.dylib", install_prefix/"lib/libLTO.dylib", install_prefix/"lib/libLLVM.dylib"

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
    assert_equal prefix.to_s, shell_output("#{bin}/llvm-config-#{ver} --prefix").chomp

    # test for sed errors since some llvm makefiles assume that sed
    # understands '\n' which is true for gnu sed and not for bsd sed.
    assert_no_match /PATH\)n/, (lib/"llvm-3.9/share/llvm/cmake/LLVMConfig.cmake").read
    system "#{bin}/llvm-config-#{ver}", "--version"
  end
end
