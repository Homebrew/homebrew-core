class Fifechan < Formula
  desc "C++ GUI library designed for games"
  homepage "https://fifengine.github.io/fifechan/"
  url "https://github.com/fifengine/fifechan/archive/refs/tags/0.1.5.tar.gz"
  sha256 "29be5ff4b379e2fc4f88ef7d8bc172342130dd3e77a3061f64c8a75efe4eba73"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "1a4e6bb77b1d87e8b0d27ebd76e5c649d6ae8a9cf3b2701e8ccac99586c69540"
    sha256 cellar: :any,                 arm64_sequoia: "95096b9ae6dc3ecfddd7213be81e5fa0c52d10f8f2534611de6e6f8efbf0ef47"
    sha256 cellar: :any,                 arm64_sonoma:  "ab1d7c0aa1c9f1576dc1c9debb66969e450914ed00f69d4a83d55afea3fcacd0"
    sha256 cellar: :any,                 sonoma:        "626e48ecf21a329ccdfbf0a0aa86e2b10d9500df48a0ad2353410b11394057c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34fb16feb5a2d79ca14f47b7f1c685b53b260252a2ab61ad8d1a0dadc21a9700"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6536748d6cdcc530a53baa0a3fb57ee9cab21225b52026f1c16fd41203585630"
  end

  depends_on "cmake" => :build

  depends_on "allegro"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_ttf"

  on_linux do
    depends_on "mesa"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                    "-DENABLE_SDL_CONTRIB=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
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

    system ENV.cxx, "fifechan_test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-lfifechan", "-o", "fifechan_test"
    system "./fifechan_test"
  end
end
