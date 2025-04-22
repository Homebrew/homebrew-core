class Flang < Formula
  desc "LLVM Fortran Frontend"
  homepage "https://flang.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.3/llvm-project-20.1.3.src.tar.xz"
  sha256 "b6183c41281ee3f23da7fda790c6d4f5877aed103d1e759763b1008bdd0e2c50"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fbaaed9ccb2b40781a8fefa992af20aa59e855d5ef101163be5f70403a3d3633"
    sha256 cellar: :any,                 arm64_sonoma:  "177722e1108e382936f581e9657556c578ddde2cc98687f12fdca6ccb1a3f990"
    sha256 cellar: :any,                 arm64_ventura: "f01d3e46299737051fd77540e46f3434f8949e9f5a988da5c43dcd900e3e705b"
    sha256 cellar: :any,                 sonoma:        "1d55cea0d255c6b6ac2ac5fa36ccdbdde0549f2aff29797eef022c2e830abb4d"
    sha256 cellar: :any,                 ventura:       "607bdbd4e004d4aa7ed04c2f9505ee42242fbf2b1c6ec054c26fea0af4cb71c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "542000b67a799dc07bd5c9d6e9cce0a89822081919601bd9bf0096dcff66d6ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8c7c2d9d6843344a4a9ebe1ce260464c8c67517d828c5396e2e54c6ecf8a0fb"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  # Building with GCC fails at linking with an obscure error.
  fails_with :gcc

  def flang_driver
    "flang-new"
  end

  def llvm
    Formula["llvm"]
  end

  def install
    # Generate omp_lib.h and omp_lib.F90 to be used by flang build
    system "cmake", "-S", "openmp", "-B", "build/projects/openmp", *std_cmake_args

    args = %W[
      -DLLVM_TOOL_OPENMP_BUILD=ON
      -DCLANG_DIR=#{llvm.opt_lib}/cmake/clang
      -DFLANG_INCLUDE_TESTS=OFF
      -DFLANG_REPOSITORY_STRING=#{tap&.issues_url}
      -DFLANG_STANDALONE_BUILD=ON
      -DFLANG_VENDOR=#{tap&.user}
      -DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm
      -DLLVM_ENABLE_EH=OFF
      -DLLVM_ENABLE_LTO=ON
      -DLLVM_USE_SYMLINKS=ON
      -DMLIR_DIR=#{llvm.opt_lib}/cmake/mlir
      -DMLIR_LINK_MLIR_DYLIB=ON
    ]
    args << "-DFLANG_VENDOR_UTI=sh.brew.flang" if tap&.official?
    # FIXME: Setting `BUILD_SHARED_LIBS=ON` causes the just-built flang to throw ICE on macOS
    args << "-DBUILD_SHARED_LIBS=ON" if OS.linux?

    ENV.append_to_cflags "-ffat-lto-objects" if OS.linux? # Unsupported on macOS.
    system "cmake", "-S", "flang", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    return if OS.linux?

    libexec.install bin.children
    bin.install_symlink libexec.children

    # Help `flang-new` driver find `libLTO.dylib` and runtime libraries
    resource_dir = Utils.safe_popen_read(llvm.opt_bin/"clang", "-print-resource-dir").chomp
    resource_dir.gsub!(llvm.prefix.realpath, llvm.opt_prefix)
    (libexec/"flang.cfg").atomic_write <<~CONFIG
      -Wl,-lto_library,#{llvm.opt_lib}/libLTO.dylib
      -resource-dir=#{resource_dir}
    CONFIG

    # Convert LTO-generated bitcode in our static archives to MachO.
    # Not needed on Linux because of `-ffat-lto-objects`
    # See equivalent code in `llvm.rb`.
    lib.glob("*.a").each do |static_archive|
      mktemp do
        system llvm.opt_bin/"llvm-ar", "x", static_archive
        rebuilt_files = []

        Pathname.glob("*.o").each do |bc_file|
          file_type = Utils.safe_popen_read("file", "--brief", bc_file)
          next unless file_type.match?(/^LLVM (IR )?bitcode/)

          rebuilt_files << bc_file
          system ENV.cc, "-fno-lto", "-Wno-unused-command-line-argument",
                         "-x", "ir", bc_file, "-c", "-o", bc_file
        end

        system llvm.opt_bin/"llvm-ar", "r", static_archive, *rebuilt_files if rebuilt_files.present?
      end
    end
  end

  test do
    # FIXME: We should remove the two variables below from the environment
    #        to test that `flang` can find our config files correctly, but
    #        this seems to break CI (but can't be reproduced locally).
    # ENV.delete "CPATH"
    # ENV.delete "SDKROOT"

    (testpath/"hello.f90").write <<~FORTRAN
      PROGRAM hello
        WRITE(*,'(A)') 'Hello World!'
      ENDPROGRAM
    FORTRAN

    (testpath/"test.f90").write <<~FORTRAN
      integer,parameter::m=10000
      real::a(m), b(m)
      real::fact=0.5

      do concurrent (i=1:m)
        a(i) = a(i) + fact*b(i)
      end do
      write(*,"(A)") "Done"
      end
    FORTRAN

    system bin/flang_driver, "-v", "hello.f90", "-o", "hello"
    assert_equal "Hello World!", shell_output("./hello").chomp

    system bin/flang_driver, "-v", "test.f90", "-o", "test"
    assert_equal "Done", shell_output("./test").chomp

    (testpath/"omptest.f90").write <<~FORTRAN
      PROGRAM omptest
      USE omp_lib
      !$OMP PARALLEL NUM_THREADS(4)
      WRITE(*,'(A,I1,A,I1)') 'Hello from thread ', OMP_GET_THREAD_NUM(), ', nthreads ', OMP_GET_NUM_THREADS()
      !$OMP END PARALLEL
      ENDPROGRAM
    FORTRAN

    openmp_flags = %w[-fopenmp]
    openmp_flags += if OS.mac?
      %W[-L#{llvm.opt_lib}]
    else
      libomp_dir = llvm.opt_lib/Utils.safe_popen_read(llvm.opt_bin/"clang", "--print-target-triple").chomp
      %W[-L#{libomp_dir} -Wl,-rpath,#{libomp_dir} -Wl,-rpath,#{lib}]
    end
    system bin/flang_driver, "-v", *openmp_flags, "omptest.f90", "-o", "omptest"
    testresult = shell_output("./omptest")

    expected_result = <<~EOS
      Hello from thread 0, nthreads 4
      Hello from thread 1, nthreads 4
      Hello from thread 2, nthreads 4
      Hello from thread 3, nthreads 4
    EOS

    sorted_testresult = testresult.split("\n").sort.join("\n")
    assert_equal expected_result.strip, sorted_testresult.strip

    (testpath/"runtimes.f90").write <<~FORTRAN
      Program main
        Complex :: y
        y = y/2
      End Program
    FORTRAN
    system bin/flang_driver, "-v", "runtimes.f90"

    return if OS.linux?

    system "ar", "x", lib/"libFortranCommon.a"
    testpath.glob("*.o").each do |object_file|
      refute_match(/^LLVM (IR )?bitcode/, shell_output("file --brief #{object_file}"))
    end
  end
end
