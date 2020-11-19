class Flang < Formula
  desc "Fortran front end for LLVM"
  homepage "https://llvm.org"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/llvm-project-11.0.0.tar.xz"
  sha256 "b7b639fc675fa1c86dd6d0bc32267be9eb34451748d2efd03f674b773000e92b"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "llvm"

  def install
    cd "flang"

    llvm_cmake_dir = "#{Formula["llvm"].opt_prefix}/lib/cmake"

    args = %W[
      -DLLVM_DIR=#{llvm_cmake_dir}/llvm
      -DMLIR_DIR=#{llvm_cmake_dir}/mlir
    ]

    mkdir "build" do
      system "cmake", "-G", "Unix Makefiles", "..", *std_cmake_args, *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.f90").write <<~EOS
      PROGRAM test
        WRITE(*,'(A)') 'Hello World!'
      ENDPROGRAM
    EOS

    system "#{bin}/flang", "test.f90", "-o", "test"
    assert_equal "Hello World!", shell_output("./test").chomp
  end
end
