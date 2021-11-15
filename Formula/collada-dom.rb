class ColladaDom < Formula
  desc "C++ library for loading and saving COLLADA data"
  homepage "https://www.khronos.org/collada/wiki/Portal:COLLADA_DOM"
  url "https://github.com/rdiankov/collada-dom/archive/v2.5.0.tar.gz"
  sha256 "3be672407a7aef60b64ce4b39704b32816b0b28f61ebffd4fbd02c8012901e0d"
  head "https://github.com/rdiankov/collada-dom.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "d7bfd664531c0f11f85f7133a8090627a39869cfc69d16611420c4c189541e50"
    sha256               arm64_big_sur:  "74fdb739480d5afe0a658201d2ac35bbcc3612ba67760072fd6f9984bac0de89"
    sha256 cellar: :any, monterey:       "7a130a67b845787b315e43d2f7ca35e5a28d4bed3f39e58d3fe4ef976bef5c70"
    sha256               big_sur:        "b7c0c6d35d2af29ac7351dcdca28d85dc31a242c994ff5a4242982c3859380c0"
    sha256               catalina:       "5e86a0dfc3311b0c2bc49017493f4c729a42b0a1d8e6c8a8bb2c7145197f9509"
    sha256               mojave:         "67da6177f67deeba4a08cc0648766856f647eb54ca9cfdf8fd61a2e665330614"
    sha256               high_sierra:    "a88714bbcd001a475d4222407031997af3cb34fe6214352a562021770a09a560"
    sha256               sierra:         "69a6c5f038f7d622130b272ac2c3b35beffb11b5ab0c4b080de422b68ebd7466"
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
