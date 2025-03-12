class Lfortran < Formula
  desc "Interactive Fortran compiler"
  homepage "https://lfortran.org/"
  url "https://github.com/lfortran/lfortran/releases/download/v0.48.0/lfortran-0.48.0.tar.gz"
  sha256 "13569cd83a00ec03473f5425c31e9420f185bbc717d70919b14e7f3a7fb52bba"
  license all_of: [
    "BSD-3-Clause",
    "MIT",
    "NCSA",
    "Apache-2.0" => { with: "LLVM-exception" },
    any_of: ["MIT", "WTFPL"],
  ]

  depends_on "cmake" => :build
  depends_on "llvm@18"
  depends_on "zstd"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DWITH_LLVM=ON",
                    "-DWITH_RUNTIME_LIBRARY=OFF",
                    "-DWITH_ZLIB=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/expr2.f90", testpath
    system bin/"lfortran", testpath/"expr2.f90"
  end
end
