class Libtrng < Formula
  desc "Tina's Random Number Generator Library"
  homepage "https://www.numbercrunch.de/trng/"
  url "https://www.numbercrunch.de/trng/trng-4.22.tar.gz"
  sha256 "6acff0a6136e41cbf0b265ae1f4392c8f4394ecfe9803bc98255e9e8d926f3d8"

  bottle do
    cellar :any
    sha256 "db8bf329be7d9ed42cc55144ee0ac1b3f44976fd05bf208003860da9128480d5" => :catalina
    sha256 "5ec98840f9e339911ef1cd9d666160005ad73dc9191e8954d5f96bead5ae404c" => :mojave
    sha256 "c6ed745a330d0da3123467cb19dd6f4c8f6871aed54b4f6addd813271599a2d6" => :high_sierra
    sha256 "54e596853cd0ea1b49dd62d0d3fc5f559063572a6f19e3fb26ef09ed19a01564" => :sierra
    sha256 "e821f8b59abe5f15689ac8720539bd258eab64f83ecfa6047406e4c11884bdef" => :el_capitan
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
