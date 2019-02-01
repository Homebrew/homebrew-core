class Cpplocate < Formula
  desc "Cross-platform C++ library providing tools for applications to locate themselves, their data assets as well as dependent modules."
  homepage "https://cpplocate.org/"
  url "https://github.com/cginternals/cpplocate/archive/v2.1.0.tar.gz"
  sha256 "da70ff59e490dd05434db093b06bb0775582d859da691cd3d1a917abb24b5fc8"
  
  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "cmake", "--build", ".", "--target", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS
      #include <cpplocate/cpplocate.h>
      int main(void)
      {
        const std::string executablePath = cpplocate::getExecutablePath();
      }
      EOS
    system ENV.cxx, "-o", "test", "test.cpp", "-std=c++11",
                    "-I#{include}/cpplocate", "-I#{lib}/cpplocate",
                    "-lcpplocate", *ENV.cflags.to_s.split
    system "./test"
  end
end
