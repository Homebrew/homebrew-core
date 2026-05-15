class Fifechan < Formula
  desc "C++ GUI library designed for games"
  homepage "https://fifengine.github.io/fifechan/"
  url "https://github.com/fifengine/fifechan/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "df3cba475716346fd27f963b9b027a02a92f697466596a3cc215a2b97d543c76"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3afa19376cef9580d0dccec234ad9f2b47fe5746c0f0767a24e6f9873726de95"
    sha256 cellar: :any,                 arm64_sequoia: "ea6f782dd2abca88671b5035a092c2045b967970a5e6d21a1a716a91cad564d7"
    sha256 cellar: :any,                 arm64_sonoma:  "c9f12983f479864f035e376ad5146b7a52f1047d7827969837db31a23fd12c2c"
    sha256 cellar: :any,                 sonoma:        "76b45ab899098163e2456b1512e6b406b632ac1344574486f607ae81d724aab8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a81504342348c5a0788969fdb1bb8d47ccab747ac60fc55023b74fe7b33737a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "265e67f5dca8783d14e90deeab28638a7f473028091f1138306499fb61995575"
  end

  depends_on "cmake" => :build
  depends_on "utf8cpp" => :build
  depends_on "allegro"
  depends_on "freetype"
  depends_on "sdl3"
  depends_on "sdl3_image"
  depends_on "sdl3_ttf"

  on_linux do
    depends_on "mesa"
  end

  def install
    args = %W[
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DUSE_VCPKG=OFF
      -DFIFEGUI_EXAMPLES=OFF
      -DFIFEGUI_TESTS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"fifechan_test.cpp").write <<~CPP
      #include <fifechan.hpp>
      int main(int n, char** c) {
        fcn::Container* mContainer = new fcn::Container();
        if (mContainer == nullptr) {
          return 1;
        }
        return 0;
      }
    CPP

    system ENV.cxx, "fifechan_test.cpp", "-std=c++20", "-I#{include}", "-L#{lib}", "-lfifechan", "-o", "fifechan_test"
    system "./fifechan_test"
  end
end
