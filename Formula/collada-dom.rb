class ColladaDom < Formula
  desc "C++ library for loading and saving COLLADA data"
  homepage "https://www.khronos.org/collada/wiki/Portal:COLLADA_DOM"
  url "https://github.com/rdiankov/collada-dom/archive/v2.5.0.tar.gz"
  sha256 "3be672407a7aef60b64ce4b39704b32816b0b28f61ebffd4fbd02c8012901e0d"
  head "https://github.com/rdiankov/collada-dom.git"

  bottle do
    sha256 "59315cc7de779a0111beba6d3d7144c47827815f3b394de90fbfcf086e6b28d2" => :mojave
    sha256 "21de8eab55b0011919fff439eeabc87f7dc1fe6a886ef0c2c3205fd21532d338" => :high_sierra
    sha256 "100e69e1bc65b07f00dcb9d9baf290a727e39ecbf01d27b9a62d26ac14abb59b" => :sierra
    sha256 "98e726f47020580acc1a10be5366394fb137fc4729e3446e5e0130a69b2d38da" => :el_capitan
    sha256 "2be8761c8bd277b4cc720c900fff84cedbc2736a55329a9d107ded2712e97d75" => :yosemite
    sha256 "5ddb31dec3a705e99ca17ec2c6ef1bafb101eac16167d451c3e6eda2dc9c0761" => :mavericks
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
