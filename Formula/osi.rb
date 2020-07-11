class Osi < Formula
  desc "Open Solver Interface"
  homepage "https://github.com/coin-or/Osi"
  url "https://github.com/coin-or/Osi/archive/releases/0.108.6.tar.gz"
  sha256 "984a5886825e2da9bf44d8a665f4b92812f0700e451c12baf9883eaa2315fad5"
  license "EPL-1.0"

  depends_on "pkg-config" => :build
  depends_on "coinutils"

  def install
    # Work around - same as clp formula
    # Error 1: "mkdir: #{include}/osi/coin: File exists."
    mkdir include/"osi/coin"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--includedir=#{include}/osi"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <OsiSolverInterface.hpp>
      int main() {
        OsiSolverInterface *si;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lOsi",
                    "-I#{include}/osi/coin",
                    "-I#{Formula["coinutils"].include}/coinutils/coin",
                    "-o", "test"
    system "./test"
  end
end
