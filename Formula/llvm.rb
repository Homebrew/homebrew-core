class Llvm < Formula
  desc "Next-gen compiler infrastructure"
  homepage "https://llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-13.0.0/llvm-project-13.0.0.src.tar.xz"
  sha256 "6075ad30f1ac0e15f07c1bf062c1e1268c241d674f11bd32cdf0e040c71f2bf3"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  revision 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    url :homepage
    regex(/LLVM (\d+\.\d+\.\d+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "124b04767b224f74be9df06181f1e20122b39108e6926e621a7a64702c9b2796"
    sha256 cellar: :any,                 arm64_big_sur:  "1213e5b2e63bc8d8440320cccd316a04b9824eba563534e4b5cfca000c5acf29"
    sha256 cellar: :any,                 monterey:       "2d2f5c57e8cb8040031b26a81eb7355068b590a17a46034ca7ac339463eca14a"
    sha256 cellar: :any,                 big_sur:        "dc0ac71f6ce7183b0fa4745fd94e08c55770dd1ee6d38d63f0c503d644937bb6"
    sha256 cellar: :any,                 catalina:       "dbcd8e6f48bf03b4730b92f4fe6351af97addc2db3eefde3ba85402b120368f5"
    sha256 cellar: :any,                 mojave:         "d2e8294ee877ecb1cf6b3d36f1f8bbc5f7749306b3b25ef988886600e931b7b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e113ff32922d209fb85a0a6ba11931a2996146b7f71d7ac22caf1521f72349a"
  end

  # Clang cannot find system headers if Xcode CLT is not installed
  pour_bottle? only_if: :clt_installed

  keg_only :provided_by_macos

  # https://llvm.org/docs/GettingStarted.html#requirement
  # We intentionally use Make instead of Ninja.
  # See: Homebrew/homebrew-core/issues/35513
  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "python@3.9"

  uses_from_macos "libedit"
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "glibc" if Formula["glibc"].any_version_installed?
    depends_on "pkg-config" => :build
    depends_on "binutils" # needed for gold
    depends_on "elfutils" # openmp requires <gelf.h>
    depends_on "gcc"
  end

  # Fails at building LLDB
  fails_with gcc: "5"

  def install
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

    py_ver = Language::Python.major_minor_version("python3")
    site_packages = Language::Python.site_packages("python3").delete_prefix("lib/")

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
      -DLLVM_ENABLE_Z3_SOLVER=OFF
      -DLLVM_OPTIMIZED_TABLEGEN=ON
      -DLLVM_TARGETS_TO_BUILD=all
      -DLLDB_USE_SYSTEM_DEBUGSERVER=ON
      -DLLDB_ENABLE_PYTHON=ON
      -DLLDB_ENABLE_LUA=OFF
      -DLLDB_ENABLE_LZMA=ON
      -DLLDB_PYTHON_RELATIVE_PATH=libexec/#{site_packages}
      -DLIBOMP_INSTALL_ALIASES=OFF
      -DCLANG_PYTHON_BINDINGS_VERSIONS=#{py_ver}
      -DLLVM_CREATE_XCODE_TOOLCHAIN=#{MacOS::Xcode.installed? ? "ON" : "OFF"}
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

    # gcc-5 fails at building compiler-rt. Enable PGO
    # build on Linux when we switch to Ubuntu 18.04.
    pgo_build = false
    if OS.mac?
      args << "-DLLVM_BUILD_LLVM_C_DYLIB=ON"
      args << "-DLLVM_ENABLE_LIBCXX=ON"
      args << "-DRUNTIMES_CMAKE_ARGS=-DCMAKE_INSTALL_RPATH=#{rpath}"
      args << "-DDEFAULT_SYSROOT=#{macos_sdk}" if macos_sdk

      # Skip the PGO build on HEAD installs or non-bottle source builds
      pgo_build = build.stable? && build.bottle?
    end

    if OS.linux?
      ENV.append "CXXFLAGS", "-fpermissive -Wno-free-nonheap-object"
      ENV.append "CFLAGS", "-fpermissive -Wno-free-nonheap-object"

      args << "-DLLVM_ENABLE_LIBCXX=OFF"
      args << "-DCLANG_DEFAULT_CXX_STDLIB=libstdc++"
      # Enable llvm gold plugin for LTO
      args << "-DLLVM_BINUTILS_INCDIR=#{Formula["binutils"].opt_include}"
      # Parts of Polly fail to correctly build with PIC when being used for DSOs.
      args << "-DCMAKE_POSITION_INDEPENDENT_CODE=ON"
      runtime_args = %w[
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
      ]
      args << "-DRUNTIMES_CMAKE_ARGS=#{runtime_args.join(";")}"

      # Prevent compiler-rt from building i386 targets, as this is not portable.
      args << "-DBUILTINS_CMAKE_ARGS=-DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON"
    end

    llvmpath = buildpath/"llvm"
    if pgo_build
      # We build LLVM a few times first for optimisations. See
      # https://github.com/Homebrew/homebrew-core/issues/77975

      # PGO build adapted from:
      # https://llvm.org/docs/HowToBuildWithPGO.html#building-clang-with-pgo
      # https://github.com/llvm/llvm-project/blob/33ba8bd2/llvm/utils/collect_and_build_with_pgo.py
      # https://github.com/facebookincubator/BOLT/blob/01f471e7/docs/OptimizingClang.md
      extra_args = [
        "-DLLVM_TARGETS_TO_BUILD=Native",
        "-DLLVM_ENABLE_PROJECTS=clang;compiler-rt;lld",
      ]
      cflags = ENV.cflags&.split || []
      cxxflags = ENV.cxxflags&.split || []

      # The later stage builds avoid the shims, and the build
      # will target Penryn unless otherwise specified
      if Hardware::CPU.intel?
        cflags << "-march=#{Hardware.oldest_cpu}"
        cxxflags << "-march=#{Hardware.oldest_cpu}"
      end

      if OS.mac?
        extra_args << "-DLLVM_ENABLE_LIBCXX=ON"
        extra_args << "-DDEFAULT_SYSROOT=#{macos_sdk}" if macos_sdk
      end

      extra_args << "-DCMAKE_C_FLAGS=#{cflags.join(" ")}" unless cflags.empty?
      extra_args << "-DCMAKE_CXX_FLAGS=#{cxxflags.join(" ")}" unless cxxflags.empty?

      # First, build a stage1 compiler. It might be possible to skip this step on macOS
      # and use system Clang instead, but this stage does not take too long, and we want
      # to avoid incompatibilities from generating profile data with a newer Clang than
      # the one we consume the data with.
      mkdir llvmpath/"stage1" do
        system "cmake", "-G", "Unix Makefiles", "..",
                        *extra_args, *std_cmake_args
        system "cmake", "--build", ".", "--target", "clang", "llvm-profdata", "profile"
      end

      # Our just-built Clang needs a little help finding C++ headers,
      # since we did not build libc++, and the atomic and type_traits
      # headers are not in the SDK on macOS versions before Big Sur.
      if OS.mac? && (MacOS.version <= :catalina && macos_sdk)
        toolchain_path = if MacOS::CLT.installed?
          MacOS::CLT::PKG_PATH
        else
          MacOS::Xcode.toolchain_path
        end

        cxxflags << "-isystem#{toolchain_path}/usr/include/c++/v1"
        cxxflags << "-isystem#{toolchain_path}/usr/include"
        cxxflags << "-isystem#{macos_sdk}/usr/include"

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
        instrumented_extra_args = extra_args.reject { |s| s["CMAKE_C_FLAGS"] || s["CMAKE_CXX_FLAGS"] }

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
        rescue RuntimeError
          nil
        end
      end

      # Then, generate the profile data
      mkdir llvmpath/"stage2-profdata" do
        system "cmake", "-G", "Unix Makefiles", "..",
                        "-DCMAKE_C_COMPILER=#{llvmpath}/stage2/bin/clang",
                        "-DCMAKE_CXX_COMPILER=#{llvmpath}/stage2/bin/clang++",
                        *extra_args, *std_cmake_args

        # This build is for profiling, so it is safe to ignore errors.
        begin
          system "cmake", "--build", ".", "--", "--keep-going"
        rescue RuntimeError
          nil
        end
      end

      # Merge the generated profile data
      profpath = llvmpath/"stage2/profiles"
      system llvmpath/"stage1/bin/llvm-profdata",
             "merge",
             "-output=#{profpath}/pgo_profile.prof",
             *Dir[profpath/"*.profraw"]

      # Make sure to build with our profiled compiler and use the profile data
      args << "-DCMAKE_C_COMPILER=#{llvmpath}/stage1/bin/clang"
      args << "-DCMAKE_CXX_COMPILER=#{llvmpath}/stage1/bin/clang++"
      args << "-DLLVM_PROFDATA_FILE=#{profpath}/pgo_profile.prof"

      # Silence some warnings
      cflags << "-Wno-backend-plugin"
      cxxflags << "-Wno-backend-plugin"
      args << "-DCMAKE_C_FLAGS=#{cflags.join(" ")}"
      args << "-DCMAKE_CXX_FLAGS=#{cxxflags.join(" ")}"
    end

    # Now, we can build.
    mkdir llvmpath/"build" do
      system "cmake", "-G", "Unix Makefiles", "..", *(std_cmake_args + args)
      system "cmake", "--build", "."
      system "cmake", "--build", ".", "--target", "install"
      system "cmake", "--build", ".", "--target", "install-xcode-toolchain" if MacOS::Xcode.installed?
    end

    if OS.mac? && !build.head?
      # Install versioned symlink, or else `llvm-config` doesn't work properly
      lib.install_symlink "libLLVM.dylib" => "libLLVM-#{version.major}.dylib"
    end

    # Install LLVM Python bindings
    # Clang Python bindings are installed by CMake
    (lib/site_packages).install llvmpath/"bindings/python/llvm"

    # Install Vim plugins
    %w[ftdetect ftplugin indent syntax].each do |dir|
      (share/"vim/vimfiles"/dir).install Dir["*/utils/vim/#{dir}/*.vim"]
    end

    # Install Emacs modes
    elisp.install Dir[llvmpath/"utils/emacs/*.el"] + Dir[share/"clang/*.el"]
  end

  def caveats
    <<~EOS
      To use the bundled libc++ please add the following LDFLAGS:
        LDFLAGS="-L#{opt_lib} -Wl,-rpath,#{opt_lib}"
    EOS
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/llvm-config --prefix").chomp
    assert_equal "-lLLVM-#{version.major}", shell_output("#{bin}/llvm-config --libs").chomp
    assert_equal (lib/shared_library("libLLVM-#{version.major}")).to_s,
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

    clean_version = version.to_s[/(\d+\.?)+/]

    system "#{bin}/clang", "-L#{lib}", "-fopenmp", "-nobuiltininc",
                           "-I#{lib}/clang/#{clean_version}/include",
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
    system "#{bin}/clang++", "-v",
           "-isystem", "#{opt_include}/c++/v1",
           "-std=c++11", "-stdlib=libc++", "test.cpp", "-o", "testlibc++",
           "-rtlib=compiler-rt", "-L#{opt_lib}", "-Wl,-rpath,#{opt_lib}"
    assert_includes (testpath/"testlibc++").dynamically_linked_libraries,
                    (opt_lib/shared_library("libc++", "1")).to_s
    (testpath/"testlibc++").dynamically_linked_libraries.each do |lib|
      refute_match(/libstdc\+\+/, lib)
      refute_match(/libgcc/, lib)
      refute_match(/libatomic/, lib)
    end
    assert_equal "Hello World!", shell_output("./testlibc++").chomp

    on_linux do
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
      func @bad_branch() {
        br ^missing  // expected-error {{reference to an undefined block}}
      }
    EOS
    system "#{bin}/mlir-opt", "--verify-diagnostics", "test.mlir"

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
    assert_includes shell_output("#{bin}/scan-build clang++ scanbuildtest.cpp 2>&1"),
      "warning: Use of memory after it is freed"

    (testpath/"clangformattest.c").write <<~EOS
      int    main() {
          printf("Hello world!"); }
    EOS
    assert_equal "int main() { printf(\"Hello world!\"); }\n",
      shell_output("#{bin}/clang-format -style=google clangformattest.c")

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
