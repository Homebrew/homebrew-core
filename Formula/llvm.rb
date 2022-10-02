class Llvm < Formula
  desc "Next-gen compiler infrastructure"
  homepage "https://llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.1/llvm-project-15.0.1.src.tar.xz"
  sha256 "f25ce2d4243bebf527284eb7be7f6f56ef454fca8b3de9523f7eb4efb8d26218"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a8b90d6a212c1e41e0017155f3e756868914926b03a09fd297424773bd439cdc"
    sha256 cellar: :any,                 arm64_big_sur:  "ef56c6cb10be540aec9a0fedb33d5299423ae7f234468643e8fb3a7844dad52d"
    sha256 cellar: :any,                 monterey:       "98b54b977a128edd7c4bc256f7047241932616440ca128195e28c5869a87bc1f"
    sha256 cellar: :any,                 big_sur:        "502b9d20511b555fd7c0c03f072a89625dfdeab970768c5a2635f69b723de0af"
    sha256 cellar: :any,                 catalina:       "685bbce0130e71dad864e4ef7c83ea629f47d3abaf56dd4608dacb4bcb0ee426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f0ff2e347647e83d812c17ee088ea4dcc34c5edb6b2f67ace1d5fe2c36e9571"
  end

  # Clang cannot find system headers if Xcode CLT is not installed
  pour_bottle? only_if: :clt_installed

  keg_only :provided_by_macos

  # https://llvm.org/docs/GettingStarted.html#requirement
  # We intentionally use Make instead of Ninja.
  # See: Homebrew/homebrew-core/issues/35513
  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "python@3.10"
  depends_on "six"
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

  def python3
    "python3.10"
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
      -DLLDB_PYTHON_EXE_RELATIVE_PATH=#{which(python3).relative_path_from(prefix)}
      -DLIBOMP_INSTALL_ALIASES=OFF
      -DCLANG_PYTHON_BINDINGS_VERSIONS=#{python_versions.join(";")}
      -DLLVM_CREATE_XCODE_TOOLCHAIN=OFF
      -DCLANG_FORCE_MATCHING_LIBCLANG_SOVERSION=OFF
      -DPACKAGE_VENDOR=#{tap.user}
      -DBUG_REPORT_URL=#{tap.issues_url}
      -DCLANG_VENDOR_UTI=org.#{tap.user.downcase}.clang
    ]

    macos_sdk = MacOS.sdk_path_if_needed
    if MacOS.version >= :catalina
      args << "-DFFI_INCLUDE_DIR=#{macos_sdk}/usr/include/ffi"
      args << "-DFFI_LIBRARY_DIR=#{macos_sdk}/usr/lib"
    else
      args << "-DFFI_INCLUDE_DIR=#{Formula["libffi"].opt_include}"
      args << "-DFFI_LIBRARY_DIR=#{Formula["libffi"].opt_lib}"
    end

    runtimes_cmake_args = []
    builtins_cmake_args = []

    # Skip the PGO build on HEAD installs or non-bottle source builds
    # Catalina and earlier requires too many hacks to build with PGO.
    # FIXME: The Linux build appears to have a parallelisation issue,
    #        so avoid a painfully slow serial build until that's resolved.
    pgo_build = build.stable? && build.bottle? && (MacOS.version > :catalina)

    if OS.mac?
      args << "-DLLVM_BUILD_LLVM_C_DYLIB=ON"
      args << "-DLLVM_ENABLE_LIBCXX=ON"
      args << "-DLIBCXX_INSTALL_LIBRARY_DIR=#{lib}/c++"
      args << "-DLIBCXXABI_INSTALL_LIBRARY_DIR=#{lib}/c++"
      args << "-DDEFAULT_SYSROOT=#{macos_sdk}" if macos_sdk
      runtimes_cmake_args << "-DCMAKE_INSTALL_RPATH=#{loader_path}"

      # Prevent CMake from defaulting to `lld` when it's found next to `clang`.
      # This can be removed after CMake 3.25. See:
      # https://gitlab.kitware.com/cmake/cmake/-/merge_requests/7671
      args << "-DLLVM_USE_LINKER=ld"
      [args, runtimes_cmake_args, builtins_cmake_args].each do |arg_array|
        arg_array << "-DCMAKE_LINKER=ld"
      end

      # Disable builds for OSes not supported by the CLT SDK.
      clt_sdk_support_flags = %w[I WATCH TV].map { |os| "-DCOMPILER_RT_ENABLE_#{os}OS=OFF" }
      builtins_cmake_args += clt_sdk_support_flags
    else
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
      # `compiler-rt` to consumer profile data.
      stage1_targets = ["clang", "llvm-profdata", "compiler-rt"]
      stage1_targets += if OS.mac?
        extra_args << "-DLLVM_ENABLE_LIBCXX=ON"
        # Prevent CMake from defaulting to `lld` when it's found next to `clang`.
        # This can be removed after CMake 3.25. See:
        # https://gitlab.kitware.com/cmake/cmake/-/merge_requests/7671
        extra_args << "-DLLVM_USE_LINKER=ld"
        extra_args << "-DCMAKE_LINKER=ld"
        extra_args += clt_sdk_support_flags

        # NOTE: do not enable LTO on Linux, because this creates static archives that are not portable.
        #       This is not an issue on macOS, where bottles are built and installed on the same version.
        args << "-DLLVM_ENABLE_LTO=Thin"
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
        system "cmake", "-G", "Unix Makefiles", "..", *extra_args, *std_cmake_args
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
          HOMBEREW_PREFIX/"lib",
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
        instrumented_cflags = cflags + ["-Xclang -mllvm -Xclang -vp-counters-per-site=6"]
        instrumented_cxxflags = cxxflags + ["-Xclang -mllvm -Xclang -vp-counters-per-site=6"]
        instrumented_extra_args = extra_args.reject { |s| s[/CMAKE_C(XX)?_FLAGS/] }

        system "cmake", "-G", "Unix Makefiles", "..",
                        "-DCMAKE_C_COMPILER=#{llvmpath}/stage1/bin/clang",
                        "-DCMAKE_CXX_COMPILER=#{llvmpath}/stage1/bin/clang++",
                        "-DLLVM_BUILD_INSTRUMENTED=IR",
                        "-DLLVM_BUILD_RUNTIME=NO",
                        "-DCMAKE_C_FLAGS=#{instrumented_cflags.join(" ")}",
                        "-DCMAKE_CXX_FLAGS=#{instrumented_cxxflags.join(" ")}",
                        *instrumented_extra_args, *std_cmake_args
        system "cmake", "--build", ".", "--target", "clang", "lld"

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
        system "cmake", "-G", "Unix Makefiles", "..",
                        "-DCMAKE_C_COMPILER=#{llvmpath}/stage2/bin/clang",
                        "-DCMAKE_CXX_COMPILER=#{llvmpath}/stage2/bin/clang++",
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
      system "cmake", "-G", "Unix Makefiles", "..", *(std_cmake_args + args)
      # Linux fails with:
      # No rule to make target '#{buildpath}/llvm/build/lib/libunwind.so'
      ENV.deparallelize if OS.linux?
      system "cmake", "--build", "."
      system "cmake", "--build", ".", "--target", "install"
    end

    if OS.mac?
      # Get the version from `llvm-config` to get the correct HEAD version too.
      llvm_version = Version.new(Utils.safe_popen_read(bin/"llvm-config", "--version").strip)
      soversion = llvm_version.major.to_s
      soversion << "git" if build.head?

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

    # Install LLVM Python bindings
    # Clang Python bindings are installed by CMake
    (lib/site_packages).install llvmpath/"bindings/python/llvm"

    # Create symlinks so that the Python bindings can be used with alternative Python versions
    python_versions.each do |py_ver|
      next if py_ver == Language::Python.major_minor_version(python3).to_s

      (lib/"python#{py_ver}/site-packages").install_symlink (lib/site_packages).children
    end

    # Install Vim plugins
    %w[ftdetect ftplugin indent syntax].each do |dir|
      (share/"vim/vimfiles"/dir).install Pathname.glob("*/utils/vim/#{dir}/*.vim")
    end

    # Install Emacs modes
    elisp.install llvmpath.glob("utils/emacs/*.el") + share.glob("clang/*.el")

    return if OS.linux? || !pgo_build

    # Convert LTO-generated bitcode in our static archives to MachO. Adapted from Fedora:
    # https://src.fedoraproject.org/rpms/redhat-rpm-config/blob/rawhide/f/brp-llvm-compile-lto-elf
    lib.glob("*.a").each do |static_archive|
      mktemp do
        system bin/"llvm-ar", "x", static_archive
        Pathname.glob("*.o").each do |bc_file|
          file_type = Utils.safe_popen_read("file", bc_file)
          next unless file_type.match?("LLVM bitcode")

          system bin/"clang", "-fno-lto", "-Wno-unused-command-line-argument",
                              "-x", "ir", bc_file, "-c", "-o", bc_file
          system bin/"llvm-ar", "r", static_archive, bc_file
        end
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
    llvm_version = Version.new(Utils.safe_popen_read(bin/"llvm-config", "--version").strip)
    soversion = llvm_version.major.to_s
    soversion << "git" if head?

    assert_equal version, llvm_version unless head?
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
                           "-I#{lib}/clang/#{llvm_version.major_minor_patch}/include",
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

    # Testing Command Line Tools
    if MacOS::CLT.installed?
      toolchain_path = "/Library/Developer/CommandLineTools"
      system "#{bin}/clang++", "-v",
             "-isysroot", MacOS::CLT.sdk_path,
             "-isystem", "#{toolchain_path}/usr/include/c++/v1",
             "-isystem", "#{toolchain_path}/usr/include",
             "-isystem", "#{MacOS::CLT.sdk_path}/usr/include",
             "-std=c++11", "test.cpp", "-o", "testCLT++"
      assert_includes MachO::Tools.dylibs("testCLT++"), "/usr/lib/libc++.1.dylib"
      assert_equal "Hello World!", shell_output("./testCLT++").chomp
      system "#{bin}/clang", "-v", "test.c", "-o", "testCLT"
      assert_equal "Hello World!", shell_output("./testCLT").chomp
    end

    # Testing Xcode
    if MacOS::Xcode.installed?
      system "#{bin}/clang++", "-v",
             "-isysroot", MacOS::Xcode.sdk_path,
             "-isystem", "#{MacOS::Xcode.toolchain_path}/usr/include/c++/v1",
             "-isystem", "#{MacOS::Xcode.toolchain_path}/usr/include",
             "-isystem", "#{MacOS::Xcode.sdk_path}/usr/include",
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
