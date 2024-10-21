class Flang < Formula
  desc "LLVM Fortran Frontend"
  homepage "https://flang.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.2/llvm-project-19.1.2.src.tar.xz"
  sha256 "3666f01fc52d8a0b0da83e107d74f208f001717824be0b80007f529453aa1e19"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "27ac24add409b9d5625b9b76be498d28e9679f5b623e7bba4bdce7ab5e0f8fd4"
    sha256 cellar: :any,                 arm64_sonoma:  "ccb62aacc3bf88d1d90cd54c0a9a46853e81db56da569f2c06447e347e9171c7"
    sha256 cellar: :any,                 arm64_ventura: "af6152f4c4bfa44381dcf315e4fe410c42049564b644985ea956ae77ead11a4d"
    sha256 cellar: :any,                 sonoma:        "d20e249d059695374646c2630c062de6ce1104033ab5b582121639053ec0a610"
    sha256 cellar: :any,                 ventura:       "663de6e3ba2a070367cb0c8fd4c7eb42182d844342835f1ed18c80f4c10bcd07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5708a60af8feca789467e0e03ceddd2f3e38532b082ed0e238487e18c7675c53"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  # Building with GCC fails at linking with an obscure error.
  fails_with :gcc

  def flang_driver
    "flang-new"
  end

  def install
    llvm = Formula["llvm"]
    # NOTE: Setting `BUILD_SHARED_LIBRARIES=ON` causes the just-built flang to throw ICE.
    args = %W[
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
    ]
    args << "-DFLANG_VENDOR_UTI=sh.brew.flang" if tap&.official?

    ENV.append_to_cflags "-ffat-lto-objects" if OS.linux? # Unsupported on macOS.
    install_prefix = libexec
    system "cmake", "-S", "flang", "-B", "build", *args, *std_cmake_args(install_prefix:)
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    libexec.find do |pn|
      next if pn.directory?

      subdir = pn.relative_path_from(libexec).dirname
      (prefix/subdir).install_symlink pn
    end

    # Our LLVM is built with exception-handling, which requires linkage with the C++ standard library.
    # TODO: Remove this if/when we've rebuilt LLVM with `LLVM_ENABLE_EH=OFF`.
    cxx_stdlib = OS.mac? ? "-lc++" : "-lstdc++"
    cxx_stdlib << "\n"
    (libexec/"bin/flang.cfg").atomic_write cxx_stdlib

    return if OS.linux?

    # Convert LTO-generated bitcode in our static archives to MachO.
    # Not needed on Linux because of `-ffat-lto-objects`
    # See equivalent code in `llvm.rb`.
    install_prefix.glob("lib/*.a").each do |static_archive|
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

    # The `flang-new` driver expects `libLTO.dylib` to be in the same prefix,
    # but it actually lives in LLVM's prefix.
    ln_sf Formula["llvm"].opt_lib/shared_library("libLTO"), install_prefix/"lib"
  end

  def caveats
    <<~EOS
      Homebrew LLVM is built with LLVM_ENABLE_EH=ON, so binaries built by `#{flang_driver}`
      require linkage to the C++ standard library. `#{flang_driver}` is configured to do this
      automatically.
    EOS
  end

  test do
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

    system "ar", "x", lib/"libFortranCommon.a"
    testpath.glob("*.o").each do |object_file|
      refute_match(/^LLVM (IR )?bitcode/, shell_output("file --brief #{object_file}"))
    end
  end
end
