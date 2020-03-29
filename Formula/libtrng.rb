class Libtrng < Formula
  desc "Tina's Random Number Generator Library"
  homepage "https://www.numbercrunch.de/trng/"
  url "https://www.numbercrunch.de/trng/trng-4.22.tar.gz"
  sha256 "6acff0a6136e41cbf0b265ae1f4392c8f4394ecfe9803bc98255e9e8d926f3d8"

  bottle do
    cellar :any
    sha256 "b0e5af117a32d265de30662de4d7ef61e412853f262949e86ac1ff91dfd69875" => :catalina
    sha256 "4b753374a4fb6305e417ea5d89237f6e62b47b8c9e2c034c76e26475184de48c" => :mojave
    sha256 "4f269f561d5b8b692189e90cba163578ad68b2fa83a84660d8da4d367c4a2e93" => :high_sierra
  end

  depends_on "cmake" => :build

  # Examples do not build. Should be fixed in next release.
  # https://github.com/rabauke/trng4/commit/78f7aea798b12603d9a2f6c68e19692f61c70647
  patch :DATA

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <trng/yarn2.hpp>
      #include <trng/normal_dist.hpp>
      int main()
      {
        trng::yarn2 R;
        trng::normal_dist<> normal(6.0, 2.0);
        (void)normal(R);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-ltrng4"
    system "./test"
  end
end

__END__
diff --git a/examples/CMakeLists.txt b/examples/CMakeLists.txt
index a916560..b29ab99 100644
--- a/examples/CMakeLists.txt
+++ b/examples/CMakeLists.txt
@@ -6,7 +6,7 @@ find_package(OpenMP)
 find_package(TBB)

 include_directories(..)
-link_libraries(trng4)
+link_libraries(trng4_static)
 link_directories(${PROJECT_BINARY_DIR}/trng)

 add_executable(hello_world hello_world.cc)
