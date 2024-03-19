class LlvmAT16 < Formula
  desc "Next-gen compiler infrastructure"
  homepage "https://llvm.org/"
  # TODO: Remove `six` dependency and `LLDB_USE_SYSTEM_SIX` at next release.
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.6/llvm-project-16.0.6.src.tar.xz"
  sha256 "ce5e71081d17ce9e86d7cbcfa28c4b04b9300f8fb7e78422b1feb6bc52c3028e"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(16(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "9bab38bfbe2c1e785fa2fc46929ebf75ca50eb8d20926f1b290ae103f51d4216"
    sha256 cellar: :any,                 arm64_ventura:  "833e6a2c39b667ecbb39c10f549d7e79187e8c4395c056eebae5439af4eac77c"
    sha256 cellar: :any,                 arm64_monterey: "8da9dba46e6be61025f2b40e3e67d1c154cddb5db282ee2cc063a9330bf488b9"
    sha256 cellar: :any,                 sonoma:         "336f479820f2a8fd236ef5c7cdf4d58acdc2b84879fd37586403aec3ef3c134a"
    sha256 cellar: :any,                 ventura:        "fca6a8c3cde7cf7c6c2038c28a4836b8675d62ebb9c126a29f74c960571ffae0"
    sha256 cellar: :any,                 monterey:       "9bedaf4519f8bba86b4deb6b3bbf2c1651f204b19d5789425c267c7fc94de80c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "165c4888dd34e3722ade1ea7dc35b2e4aa4ad1ead86e250cc027572862901257"
  end

  # Clang cannot find system headers if Xcode CLT is not installed
  pour_bottle? only_if: :clt_installed

  keg_only :versioned_formula

  # https://llvm.org/docs/GettingStarted.html#requirement
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "swig" => :build
  depends_on "python@3.12"
  depends_on "six" # TODO: Remove at next release.
  depends_on "z3"
  depends_on "zstd"

  uses_from_macos "libedit"
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "binutils" # needed for gold
    depends_on "elfutils" # openmp requires <gelf.h>
  end

  # Fails at building LLDB
  fails_with gcc: "5"

  # Fixes https://github.com/mesonbuild/meson/issues/11642
  # Remove at next release.
  patch do
    url "https://github.com/llvm/llvm-project/commit/ab8d4f5a122fde5740f8c084c8165f51a26c93c7.patch?full_index=1"
    sha256 "9b01de9708e4eb5cef10c18f25dd42e126306ed8cbd9d9a26bb5fbb91ac7d7a3"
  end

  def python3
    "python3.12"
  end

  def install
    # The clang bindings need a little help finding our libclang.
    inreplace "clang/bindings/python/clang/cindex.py",
              /^(\s*library_path\s*=\s*)None$/,
              "\\1'#{lib}'"

    projects = %w[
      clang
      clang-tools-extra
      lld
      lldb
      mlir
      polly
    ]
    runtimes = %w[
      compiler-rt
      libcxx
      libcxxabi
      libunwind
    ]
    if OS.mac?
      runtimes << "openmp"
    else
      projects << "openmp"
    end

    python_versions = Formula.names
                             .select { |name| name.start_with? "python@" }
                             .map { |py| py.delete_prefix("python@") }
    site_packages = Language::Python.site_packages(python3).delete_prefix("lib/")

    # Apple's libstdc++ is too old to build LLVM
    ENV.libcxx if ENV.compiler == :clang

    # compiler-rt has some iOS simulator features that require i386 symbols
    # I'm assuming the rest of clang needs support too for 32-bit compilation
    # to work correctly, but if not, perhaps universal binaries could be
    # limited to compiler-rt. llvm makes this somewhat easier because compiler-rt
    # can almost be treated as an entirely different build from llvm.
    ENV.permit_arch_flags

    # we install the lldb Python module into libexec to prevent users from
    # accidentally importing it with a non-Homebrew Python or a Homebrew Python
    # in a non-default prefix. See https://lldb.llvm.org/resources/caveats.html
    args = %W[
      -DLLVM_ENABLE_PROJECTS=#{projects.join(";")}
      -DLLVM_ENABLE_RUNTIMES=#{runtimes.join(";")}
      -DLLVM_POLLY_LINK_INTO_TOOLS=ON
      -DLLVM_BUILD_EXTERNAL_COMPILER_RT=ON
      -DLLVM_LINK_LLVM_DYLIB=ON
      -DLLVM_ENABLE_EH=ON
      -DLLVM_ENABLE_FFI=ON
      -DLLVM_ENABLE_RTTI=ON
      -DLLVM_INCLUDE_DOCS=OFF
      -DLLVM_INCLUDE_TESTS=OFF
      -DLLVM_INSTALL_UTILS=ON
      -DLLVM_ENABLE_Z3_SOLVER=ON
      -DLLVM_OPTIMIZED_TABLEGEN=ON
      -DLLVM_TARGETS_TO_BUILD=all
      -DLLDB_USE_SYSTEM_DEBUGSERVER=ON
      -DLLDB_ENABLE_PYTHON=ON
      -DLLDB_ENABLE_LUA=OFF
      -DLLDB_ENABLE_LZMA=ON
      -DLLDB_USE_SYSTEM_SIX=ON
      -DLLDB_PYTHON_RELATIVE_PATH=libexec/#{site_packages}
      -DLIBOMP_INSTALL_ALIASES=OFF
      -DCLANG_PYTHON_BINDINGS_VERSIONS=#{python_versions.join(";")}
      -DLLVM_CREATE_XCODE_TOOLCHAIN=OFF
      -DCLANG_FORCE_MATCHING_LIBCLANG_SOVERSION=OFF
      -DPACKAGE_VENDOR=#{tap.user}
      -DBUG_REPORT_URL=#{tap.issues_url}
      -DCLANG_VENDOR_UTI=org.#{tap.user.downcase}.clang
    ]

    runtimes_cmake_args = []
    builtins_cmake_args = []

    if OS.mac?
      macos_sdk = MacOS.sdk_path_if_needed
      if MacOS.version >= :catalina
        args << "-DFFI_INCLUDE_DIR=#{macos_sdk}/usr/include/ffi"
        args << "-DFFI_LIBRARY_DIR=#{macos_sdk}/usr/lib"
      end

      args << "-DLLVM_BUILD_LLVM_C_DYLIB=ON"
      args << "-DLLVM_ENABLE_LIBCXX=ON"
      args << "-DLIBCXX_INSTALL_LIBRARY_DIR=#{lib}/c++"
      args << "-DLIBCXXABI_INSTALL_LIBRARY_DIR=#{lib}/c++"
      args << "-DDEFAULT_SYSROOT=#{macos_sdk}" if macos_sdk
      runtimes_cmake_args << "-DCMAKE_INSTALL_RPATH=#{loader_path}"

      # Disable builds for OSes not supported by the CLT SDK.
      clt_sdk_support_flags = %w[I WATCH TV].map { |os| "-DCOMPILER_RT_ENABLE_#{os}OS=OFF" }
      builtins_cmake_args += clt_sdk_support_flags
    else
      args << "-DFFI_INCLUDE_DIR=#{Formula["libffi"].opt_include}"
      args << "-DFFI_LIBRARY_DIR=#{Formula["libffi"].opt_lib}"

      # Disable `libxml2` which isn't very useful.
      args << "-DLLVM_ENABLE_LIBXML2=OFF"
      args << "-DLLVM_ENABLE_LIBCXX=OFF"
      args << "-DCLANG_DEFAULT_CXX_STDLIB=libstdc++"
      # Enable llvm gold plugin for LTO
      args << "-DLLVM_BINUTILS_INCDIR=#{Formula["binutils"].opt_include}"
      # Parts of Polly fail to correctly build with PIC when being used for DSOs.
      args << "-DCMAKE_POSITION_INDEPENDENT_CODE=ON"
      runtimes_cmake_args += %w[
        -DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR=OFF
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON

        -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON
        -DLIBCXX_STATICALLY_LINK_ABI_IN_SHARED_LIBRARY=OFF
        -DLIBCXX_STATICALLY_LINK_ABI_IN_STATIC_LIBRARY=ON
        -DLIBCXX_USE_COMPILER_RT=ON
        -DLIBCXX_HAS_ATOMIC_LIB=OFF

        -DLIBCXXABI_ENABLE_STATIC_UNWINDER=ON
        -DLIBCXXABI_STATICALLY_LINK_UNWINDER_IN_SHARED_LIBRARY=OFF
        -DLIBCXXABI_STATICALLY_LINK_UNWINDER_IN_STATIC_LIBRARY=ON
        -DLIBCXXABI_USE_COMPILER_RT=ON
        -DLIBCXXABI_USE_LLVM_UNWINDER=ON

        -DLIBUNWIND_USE_COMPILER_RT=ON
        -DCOMPILER_RT_USE_BUILTINS_LIBRARY=ON
        -DCOMPILER_RT_USE_LLVM_UNWINDER=ON

        -DSANITIZER_CXX_ABI=libc++
        -DSANITIZER_TEST_CXX=libc++
      ]

      # Prevent compiler-rt from building i386 targets, as this is not portable.
      builtins_cmake_args << "-DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON"
    end

    # Skip the PGO build on HEAD installs or non-bottle source builds
    # Catalina and earlier requires too many hacks to build with PGO.
    pgo_build = build.stable? && build.bottle? && (MacOS.version > :catalina)
    lto_build = pgo_build && OS.mac?

    if ENV.cflags.present?
      args << "-DCMAKE_C_FLAGS=#{ENV.cflags}" unless pgo_build
      runtimes_cmake_args << "-DCMAKE_C_FLAGS=#{ENV.cflags}"
      builtins_cmake_args << "-DCMAKE_C_FLAGS=#{ENV.cflags}"
    end

    if ENV.cxxflags.present?
      args << "-DCMAKE_CXX_FLAGS=#{ENV.cxxflags}" unless pgo_build
      runtimes_cmake_args << "-DCMAKE_CXX_FLAGS=#{ENV.cxxflags}"
      builtins_cmake_args << "-DCMAKE_CXX_FLAGS=#{ENV.cxxflags}"
    end

    args << "-DRUNTIMES_CMAKE_ARGS=#{runtimes_cmake_args.join(";")}" if runtimes_cmake_args.present?
    args << "-DBUILTINS_CMAKE_ARGS=#{builtins_cmake_args.join(";")}" if builtins_cmake_args.present?

    llvmpath = buildpath/"llvm"
    if pgo_build
      # We build LLVM a few times first for optimisations. See
      # https://github.com/Homebrew/homebrew-core/issues/77975

      # PGO build adapted from:
      # https://llvm.org/docs/HowToBuildWithPGO.html#building-clang-with-pgo
      # https://github.com/llvm/llvm-project/blob/33ba8bd2/llvm/utils/collect_and_build_with_pgo.py
      # https://github.com/facebookincubator/BOLT/blob/01f471e7/docs/OptimizingClang.md

      # We build the basic parts of a toolchain to profile.
      # The extra targets on macOS are part of a default Compiler-RT build.
      extra_args = [
        "-DLLVM_TARGETS_TO_BUILD=Native#{";AArch64;ARM;X86" if OS.mac?}",
        "-DLLVM_ENABLE_PROJECTS=clang;lld",
        "-DLLVM_ENABLE_RUNTIMES=compiler-rt",
      ]

      # Our stage1 compiler includes the minimum necessary to bootstrap.
      # `llvm-profdata` is needed for profile data pre-processing, and
      # `compiler-rt` to consume profile data.
      stage1_targets = ["clang", "llvm-profdata", "compiler-rt"]
      stage1_targets += if OS.mac?
        extra_args << "-DLLVM_ENABLE_LIBCXX=ON"
        extra_args += clt_sdk_support_flags

        args << "-DLLVM_ENABLE_LTO=Thin" if lto_build
        # LTO creates object files not recognised by Apple libtool.
        args << "-DCMAKE_LIBTOOL=#{llvmpath}/stage1/bin/llvm-libtool-darwin"

        # These are needed to enable LTO.
        ["llvm-libtool-darwin", "LTO"]
      else
        # Make sure CMake doesn't try to pass C++-only flags to C compiler.
        extra_args << "-DCMAKE_C_COMPILER=#{ENV.cc}"
        extra_args << "-DCMAKE_CXX_COMPILER=#{ENV.cxx}"

        # We use this as the linker on Linux to control RPATH.
        ["lld"]
      end

      cflags = ENV.cflags&.split || []
      cxxflags = ENV.cxxflags&.split || []
      extra_args << "-DCMAKE_C_FLAGS=#{cflags.join(" ")}" unless cflags.empty?
      extra_args << "-DCMAKE_CXX_FLAGS=#{cxxflags.join(" ")}" unless cxxflags.empty?

      # First, build a stage1 compiler. It might be possible to skip this step on macOS
      # and use system Clang instead, but this stage does not take too long, and we want
      # to avoid incompatibilities from generating profile data with a newer Clang than
      # the one we consume the data with.
      mkdir llvmpath/"stage1" do
        system "cmake", "-G", "Ninja", "..", *extra_args, *std_cmake_args
        system "cmake", "--build", ".", "--target", *stage1_targets
      end

      # Barring the stage where we generate the profile data, there is no benefit to
      # rebuilding these.
      extra_args << "-DCLANG_TABLEGEN=#{llvmpath}/stage1/bin/clang-tblgen"
      extra_args << "-DLLVM_TABLEGEN=#{llvmpath}/stage1/bin/llvm-tblgen"

      if OS.linux?
        # Make sure brewed glibc will be used if it is installed.
        linux_library_paths = [
          Formula["glibc"].opt_lib,
          HOMEBREW_PREFIX/"lib",
        ]
        linux_linker_flags = linux_library_paths.map { |path| "-L#{path} -Wl,-rpath,#{path}" }
        # Add opt_libs for dependencies to RPATH.
        linux_linker_flags += deps.map(&:to_formula).map { |dep| "-Wl,-rpath,#{dep.opt_lib}" }

        [args, extra_args].each do |arg_array|
          # Add the linker paths to the arguments passed to the temporary compilers and installed toolchain.
          arg_array << "-DCMAKE_EXE_LINKER_FLAGS=#{linux_linker_flags.join(" ")}"
          arg_array << "-DCMAKE_MODULE_LINKER_FLAGS=#{linux_linker_flags.join(" ")}"
          arg_array << "-DCMAKE_SHARED_LINKER_FLAGS=#{linux_linker_flags.join(" ")}"

          # Use stage1 lld instead of ld shim so that we can control RPATH.
          arg_array << "-DLLVM_USE_LINKER=lld"
        end

        # We also need to make sure we can find headers for other formulae on Linux.
        linux_include_paths = [
          HOMEBREW_PREFIX/"include",
        ]
        linux_include_paths.each { |path| cxxflags << "-isystem#{path}" }

        # Unset CMAKE_C_COMPILER and CMAKE_CXX_COMPILER so we can set them below.
        extra_args.reject! { |s| s[/CMAKE_C(XX)?_COMPILER/] }
        extra_args.reject! { |s| s["CMAKE_CXX_FLAGS"] }
        extra_args << "-DCMAKE_CXX_FLAGS=#{cxxflags.join(" ")}"
      end

      # Next, build an instrumented stage2 compiler
      mkdir llvmpath/"stage2" do
        # LLVM Profile runs out of static counters
        # https://reviews.llvm.org/D92669, https://reviews.llvm.org/D93281
        # Without this, the build produces many warnings of the form
        # LLVM Profile Warning: Unable to track new values: Running out of static counters.
        instrumented_cflags = cflags + %w[-Xclang -mllvm -Xclang -vp-counters-per-site=6]
        instrumented_cxxflags = cxxflags + %w[-Xclang -mllvm -Xclang -vp-counters-per-site=6]
        instrumented_extra_args = extra_args.reject { |s| s[/CMAKE_C(XX)?_FLAGS/] }

        system "cmake", "-G", "Ninja", "..",
                        "-DCMAKE_C_COMPILER=#{llvmpath}/stage1/bin/clang",
                        "-DCMAKE_CXX_COMPILER=#{llvmpath}/stage1/bin/clang++",
                        "-DLLVM_BUILD_INSTRUMENTED=IR",
                        "-DLLVM_BUILD_RUNTIME=NO",
                        "-DCMAKE_C_FLAGS=#{instrumented_cflags.join(" ")}",
                        "-DCMAKE_CXX_FLAGS=#{instrumented_cxxflags.join(" ")}",
                        *instrumented_extra_args, *std_cmake_args
        system "cmake", "--build", ".", "--target", "clang", "lld", "runtimes"

        # We run some `check-*` targets to increase profiling
        # coverage. These do not need to succeed.
        begin
          system "cmake", "--build", ".", "--target", "check-clang", "check-llvm", "--", "--keep-going"
        rescue BuildError
          nil
        end
      end

      # Then, generate the profile data
      mkdir llvmpath/"stage2-profdata" do
        system "cmake", "-G", "Ninja", "..",
                        "-DCMAKE_C_COMPILER=#{llvmpath}/stage2/bin/clang",
                        "-DCMAKE_CXX_COMPILER=#{llvmpath}/stage2/bin/clang++",
                        "-DLLVM_BUILD_RUNTIMES=OFF",
                        *extra_args.reject { |s| s["TABLEGEN"] },
                        *std_cmake_args

        # This build is for profiling, so it is safe to ignore errors.
        begin
          system "cmake", "--build", ".", "--", "--keep-going"
        rescue BuildError
          nil
        end
      end

      # Merge the generated profile data
      profpath = llvmpath/"stage2/profiles"
      pgo_profile = profpath/"pgo_profile.prof"
      system llvmpath/"stage1/bin/llvm-profdata", "merge", "-output=#{pgo_profile}", *profpath.glob("*.profraw")

      # Make sure to build with our profiled compiler and use the profile data
      args << "-DCMAKE_C_COMPILER=#{llvmpath}/stage1/bin/clang"
      args << "-DCMAKE_CXX_COMPILER=#{llvmpath}/stage1/bin/clang++"
      args << "-DLLVM_PROFDATA_FILE=#{pgo_profile}"
      # `llvm-tblgen` is an install target, so let's build that.
      args << "-DCLANG_TABLEGEN=#{llvmpath}/stage1/bin/clang-tblgen"

      # Silence some warnings
      cflags << "-Wno-backend-plugin"
      cxxflags << "-Wno-backend-plugin"

      args << "-DCMAKE_C_FLAGS=#{cflags.join(" ")}"
      args << "-DCMAKE_CXX_FLAGS=#{cxxflags.join(" ")}"
    end

    # Now, we can build.
    mkdir llvmpath/"build" do
      system "cmake", "-G", "Ninja", "..", *(std_cmake_args + args)
      system "cmake", "--build", "."
      system "cmake", "--build", ".", "--target", "install"
    end

    if OS.mac?
      # Get the version from `llvm-config` to get the correct HEAD or RC version too.
      llvm_version = Utils.safe_popen_read(bin/"llvm-config", "--version").strip
      soversion = Version.new(llvm_version).major.to_s
      soversion << "git" if llvm_version.end_with?("git")
      soversion << "rc" if llvm_version.end_with?("rc")

      # Install versioned symlink, or else `llvm-config` doesn't work properly
      lib.install_symlink "libLLVM.dylib" => "libLLVM-#{soversion}.dylib"

      # Install Xcode toolchain. See:
      # https://github.com/llvm/llvm-project/blob/main/llvm/tools/xcode-toolchain/CMakeLists.txt
      # We do this manually in order to avoid:
      #   1. installing duplicates of files in the prefix
      #   2. requiring an existing Xcode installation
      xctoolchain = prefix/"Toolchains/LLVM#{llvm_version}.xctoolchain"

      system "/usr/libexec/PlistBuddy", "-c", "Add:CFBundleIdentifier string org.llvm.#{llvm_version}", "Info.plist"
      system "/usr/libexec/PlistBuddy", "-c", "Add:CompatibilityVersion integer 2", "Info.plist"
      xctoolchain.install "Info.plist"
      (xctoolchain/"usr").install_symlink [bin, include, lib, libexec, share]
    end

    # Install Vim plugins
    %w[ftdetect ftplugin indent syntax].each do |dir|
      (share/"vim/vimfiles"/dir).install Pathname.glob("*/utils/vim/#{dir}/*.vim")
    end

    # Install Emacs modes
    elisp.install llvmpath.glob("utils/emacs/*.el") + share.glob("clang/*.el")

    return unless lto_build

    # Convert LTO-generated bitcode in our static archives to MachO. Adapted from Fedora:
    # https://src.fedoraproject.org/rpms/redhat-rpm-config/blob/rawhide/f/brp-llvm-compile-lto-elf
    lib.glob("*.a").each do |static_archive|
      mktemp do
        system bin/"llvm-ar", "x", static_archive
        rebuilt_files = []

        Pathname.glob("*.o").each do |bc_file|
          file_type = Utils.safe_popen_read("file", "--brief", bc_file)
          next unless file_type.match?(/^LLVM (IR )?bitcode/)

          rebuilt_files << bc_file
          system bin/"clang", "-fno-lto", "-Wno-unused-command-line-argument",
                              "-x", "ir", bc_file, "-c", "-o", bc_file
        end

        system bin/"llvm-ar", "r", static_archive, *rebuilt_files if rebuilt_files.present?
      end
    end
  end

  def caveats
    on_macos do
      <<~EOS
        To use the bundled libc++ please add the following LDFLAGS:
          LDFLAGS="-L#{opt_lib}/c++ -Wl,-rpath,#{opt_lib}/c++"
      EOS
    end
  end

  test do
    llvm_version = Utils.safe_popen_read(bin/"llvm-config", "--version").strip
    llvm_version_major = Version.new(llvm_version).major.to_s
    soversion = llvm_version_major.dup

    if llvm_version.end_with?("git")
      soversion << "git"
    elsif llvm_version.end_with?("rc")
      soversion << "rc"
    else
      assert_equal version, llvm_version
    end

    assert_equal prefix.to_s, shell_output("#{bin}/llvm-config --prefix").chomp
    assert_equal "-lLLVM-#{soversion}", shell_output("#{bin}/llvm-config --libs").chomp
    assert_equal (lib/shared_library("libLLVM-#{soversion}")).to_s,
                 shell_output("#{bin}/llvm-config --libfiles").chomp

    (testpath/"omptest.c").write <<~EOS
      #include <stdlib.h>
      #include <stdio.h>
      #include <omp.h>
      int main() {
          #pragma omp parallel num_threads(4)
          {
            printf("Hello from thread %d, nthreads %d\\n", omp_get_thread_num(), omp_get_num_threads());
          }
          return EXIT_SUCCESS;
      }
    EOS

    system "#{bin}/clang", "-L#{lib}", "-fopenmp", "-nobuiltininc",
                           "-I#{lib}/clang/#{llvm_version_major}/include",
                           "omptest.c", "-o", "omptest"
    testresult = shell_output("./omptest")

    sorted_testresult = testresult.split("\n").sort.join("\n")
    expected_result = <<~EOS
      Hello from thread 0, nthreads 4
      Hello from thread 1, nthreads 4
      Hello from thread 2, nthreads 4
      Hello from thread 3, nthreads 4
    EOS
    assert_equal expected_result.strip, sorted_testresult.strip

    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        printf("Hello World!\\n");
        return 0;
      }
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      int main()
      {
        std::cout << "Hello World!" << std::endl;
        return 0;
      }
    EOS

    # Testing default toolchain and SDK location.
    system "#{bin}/clang++", "-v",
           "-std=c++11", "test.cpp", "-o", "test++"
    assert_includes MachO::Tools.dylibs("test++"), "/usr/lib/libc++.1.dylib" if OS.mac?
    assert_equal "Hello World!", shell_output("./test++").chomp
    system "#{bin}/clang", "-v", "test.c", "-o", "test"
    assert_equal "Hello World!", shell_output("./test").chomp

    # To test `lld`, we mock a broken `ld` to make sure it's not what's being used.
    (testpath/"fake_ld.c").write <<~EOS
      int main() { return 1; }
    EOS
    (testpath/"bin").mkpath
    system ENV.cc, "-v", "fake_ld.c", "-o", "bin/ld"
    with_env(PATH: "#{testpath}/bin:#{ENV["PATH"]}") do
      # Our fake `ld` will produce a compilation error if it is used instead of `lld`.
      system "#{bin}/clang", "-v", "test.c", "-o", "test_lld", "-fuse-ld=lld"
    end
    assert_equal "Hello World!", shell_output("./test_lld").chomp

    # These tests should ignore the usual SDK includes
    with_env(CPATH: nil) do
      # Testing Command Line Tools
      if OS.mac? && MacOS::CLT.installed?
        toolchain_path = "/Library/Developer/CommandLineTools"
        cpp_base = (MacOS.version >= :big_sur) ? MacOS::CLT.sdk_path : toolchain_path
        system "#{bin}/clang++", "-v",
               "-isysroot", MacOS::CLT.sdk_path,
               "-isystem", "#{cpp_base}/usr/include/c++/v1",
               "-isystem", "#{MacOS::CLT.sdk_path}/usr/include",
               "-isystem", "#{toolchain_path}/usr/include",
               "-std=c++11", "test.cpp", "-o", "testCLT++"
        assert_includes MachO::Tools.dylibs("testCLT++"), "/usr/lib/libc++.1.dylib"
        assert_equal "Hello World!", shell_output("./testCLT++").chomp
        system "#{bin}/clang", "-v", "test.c", "-o", "testCLT"
        assert_equal "Hello World!", shell_output("./testCLT").chomp
      end

      # Testing Xcode
      if OS.mac? && MacOS::Xcode.installed?
        cpp_base = (MacOS::Xcode.version >= "12.5") ? MacOS::Xcode.sdk_path : MacOS::Xcode.toolchain_path
        system "#{bin}/clang++", "-v",
               "-isysroot", MacOS::Xcode.sdk_path,
               "-isystem", "#{cpp_base}/usr/include/c++/v1",
               "-isystem", "#{MacOS::Xcode.sdk_path}/usr/include",
               "-isystem", "#{MacOS::Xcode.toolchain_path}/usr/include",
               "-std=c++11", "test.cpp", "-o", "testXC++"
        assert_includes MachO::Tools.dylibs("testXC++"), "/usr/lib/libc++.1.dylib"
        assert_equal "Hello World!", shell_output("./testXC++").chomp
        system "#{bin}/clang", "-v",
               "-isysroot", MacOS.sdk_path,
               "test.c", "-o", "testXC"
        assert_equal "Hello World!", shell_output("./testXC").chomp
      end

      # link against installed libc++
      # related to https://github.com/Homebrew/legacy-homebrew/issues/47149
      cxx_libdir = OS.mac? ? opt_lib/"c++" : opt_lib
      system "#{bin}/clang++", "-v",
             "-isystem", "#{opt_include}/c++/v1",
             "-std=c++11", "-stdlib=libc++", "test.cpp", "-o", "testlibc++",
             "-rtlib=compiler-rt", "-L#{cxx_libdir}", "-Wl,-rpath,#{cxx_libdir}"
      assert_includes (testpath/"testlibc++").dynamically_linked_libraries,
                      (cxx_libdir/shared_library("libc++", "1")).to_s
      (testpath/"testlibc++").dynamically_linked_libraries.each do |lib|
        refute_match(/libstdc\+\+/, lib)
        refute_match(/libgcc/, lib)
        refute_match(/libatomic/, lib)
      end
      assert_equal "Hello World!", shell_output("./testlibc++").chomp
    end

    if OS.linux?
      # Link installed libc++, libc++abi, and libunwind archives both into
      # a position independent executable (PIE), as well as into a fully
      # position independent (PIC) DSO for things like plugins that export
      # a C-only API but internally use C++.
      #
      # FIXME: It'd be nice to be able to use flags like `-static-libstdc++`
      # together with `-stdlib=libc++` (the latter one we need anyways for
      # headers) to achieve this but those flags don't set up the correct
      # search paths or handle all of the libraries needed by `libc++` when
      # linking statically.

      system "#{bin}/clang++", "-v", "-o", "test_pie_runtimes",
                   "-pie", "-fPIC", "test.cpp", "-L#{opt_lib}",
                   "-stdlib=libc++", "-rtlib=compiler-rt",
                   "-static-libstdc++", "-lpthread", "-ldl"
      assert_equal "Hello World!", shell_output("./test_pie_runtimes").chomp
      (testpath/"test_pie_runtimes").dynamically_linked_libraries.each do |lib|
        refute_match(/lib(std)?c\+\+/, lib)
        refute_match(/libgcc/, lib)
        refute_match(/libatomic/, lib)
        refute_match(/libunwind/, lib)
      end

      (testpath/"test_plugin.cpp").write <<~EOS
        #include <iostream>
        __attribute__((visibility("default")))
        extern "C" void run_plugin() {
          std::cout << "Hello Plugin World!" << std::endl;
        }
      EOS
      (testpath/"test_plugin_main.c").write <<~EOS
        extern void run_plugin();
        int main() {
          run_plugin();
        }
      EOS
      system "#{bin}/clang++", "-v", "-o", "test_plugin.so",
             "-shared", "-fPIC", "test_plugin.cpp", "-L#{opt_lib}",
             "-stdlib=libc++", "-rtlib=compiler-rt",
             "-static-libstdc++", "-lpthread", "-ldl"
      system "#{bin}/clang", "-v",
             "test_plugin_main.c", "-o", "test_plugin_libc++",
             "test_plugin.so", "-Wl,-rpath=#{testpath}", "-rtlib=compiler-rt"
      assert_equal "Hello Plugin World!", shell_output("./test_plugin_libc++").chomp
      (testpath/"test_plugin.so").dynamically_linked_libraries.each do |lib|
        refute_match(/lib(std)?c\+\+/, lib)
        refute_match(/libgcc/, lib)
        refute_match(/libatomic/, lib)
        refute_match(/libunwind/, lib)
      end
    end

    # Testing mlir
    (testpath/"test.mlir").write <<~EOS
      func.func @main() {return}

      // -----

      // expected-note @+1 {{see existing symbol definition here}}
      func.func @foo() { return }

      // ----

      // expected-error @+1 {{redefinition of symbol named 'foo'}}
      func.func @foo() { return }
    EOS
    system "#{bin}/mlir-opt", "--split-input-file", "--verify-diagnostics", "test.mlir"

    (testpath/"scanbuildtest.cpp").write <<~EOS
      #include <iostream>
      int main() {
        int *i = new int;
        *i = 1;
        delete i;
        std::cout << *i << std::endl;
        return 0;
      }
    EOS
    assert_includes shell_output("#{bin}/scan-build make scanbuildtest 2>&1"),
                    "warning: Use of memory after it is freed"

    (testpath/"clangformattest.c").write <<~EOS
      int    main() {
          printf("Hello world!"); }
    EOS
    assert_equal "int main() { printf(\"Hello world!\"); }\n",
      shell_output("#{bin}/clang-format -style=google clangformattest.c")

    # Test static analyzer
    (testpath/"unreachable.c").write <<~EOS
      unsigned int func(unsigned int a) {
        unsigned int *z = 0;
        if ((a & 1) && ((a & 1) ^1))
          return *z; // unreachable
        return 0;
      }
    EOS
    system bin/"clang", "--analyze", "-Xanalyzer", "-analyzer-constraints=z3", "unreachable.c"

    # This will fail if the clang bindings cannot find `libclang`.
    with_env(PYTHONPATH: prefix/Language::Python.site_packages(python3)) do
      system python3, "-c", <<~EOS
        from clang import cindex
        cindex.Config().get_cindex_library()
      EOS
    end

    # Check that lldb can use Python
    lldb_script_interpreter_info = JSON.parse(shell_output("#{bin}/lldb --print-script-interpreter-info"))
    assert_equal "python", lldb_script_interpreter_info["language"]
    python_test_cmd = "import pathlib, sys; print(pathlib.Path(sys.prefix).resolve())"
    assert_match shell_output("#{python3} -c '#{python_test_cmd}'"),
                 pipe_output("#{bin}/lldb", <<~EOS)
                   script
                   #{python_test_cmd}
                 EOS

    # Ensure LLVM did not regress output of `llvm-config --system-libs` which for a time
    # was known to output incorrect linker flags; e.g., `-llibxml2.tbd` instead of `-lxml2`.
    # On the other hand, note that a fully qualified path to `dylib` or `tbd` is OK, e.g.,
    # `/usr/local/lib/libxml2.tbd` or `/usr/local/lib/libxml2.dylib`.
    shell_output("#{bin}/llvm-config --system-libs").chomp.strip.split.each do |lib|
      if lib.start_with?("-l")
        assert !lib.end_with?(".tbd"), "expected abs path when lib reported as .tbd"
        assert !lib.end_with?(".dylib"), "expected abs path when lib reported as .dylib"
      else
        p = Pathname.new(lib)
        if p.extname == ".tbd" || p.extname == ".dylib"
          assert p.absolute?, "expected abs path when lib reported as .tbd or .dylib"
        end
      end
    end
  end
end
