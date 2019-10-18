class ColladaDom < Formula
  desc "C++ library for loading and saving COLLADA data"
  homepage "https://www.khronos.org/collada/wiki/Portal:COLLADA_DOM"
  url "https://github.com/rdiankov/collada-dom/archive/v2.5.0.tar.gz"
  sha256 "3be672407a7aef60b64ce4b39704b32816b0b28f61ebffd4fbd02c8012901e0d"
  head "https://github.com/rdiankov/collada-dom.git"

  bottle do
    sha256 "5e86a0dfc3311b0c2bc49017493f4c729a42b0a1d8e6c8a8bb2c7145197f9509" => :catalina
    sha256 "67da6177f67deeba4a08cc0648766856f647eb54ca9cfdf8fd61a2e665330614" => :mojave
    sha256 "a88714bbcd001a475d4222407031997af3cb34fe6214352a562021770a09a560" => :high_sierra
    sha256 "69a6c5f038f7d622130b272ac2c3b35beffb11b5ab0c4b080de422b68ebd7466" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "pcre"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <dae.h>
      #include <dae/daeDom.h>

      using namespace std;

      int main()
      {
        cout << GetCOLLADA_VERSION() << endl;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}/collada-dom2.5",
                    "-L#{lib}", "-lcollada-dom2.5-dp", "-o", "test"

    # This is the DAE file version, not the package version
    assert_equal "1.5.0", shell_output("./test").chomp
  end
end
