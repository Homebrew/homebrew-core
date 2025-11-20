class Libgosu < Formula
  desc "2D game development library"
  homepage "https://libgosu.org"
  url "https://github.com/gosu/gosu/archive/refs/tags/v1.4.6.tar.gz"
  sha256 "bbd4c4a868549702e190542f0dc5be8210c8290378ae9b24a75a86e57aa8f39e"
  license "MIT"
  head "https://github.com/gosu/gosu.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "e0ecd1c01723e86606cf28780642bfe3992d3e8cf342715a13ec72ce563f30f9"
    sha256 cellar: :any,                 arm64_sequoia:  "3a5fa70c9c6f1dcdb60fbeb50e8ec544b341c25f0c9d426d5f3982948a10a427"
    sha256 cellar: :any,                 arm64_sonoma:   "e212870f51bae367a0d9e2fe223ad8b6b69562efa3f368f7ca09ca554c9d83e3"
    sha256 cellar: :any,                 arm64_ventura:  "521365479b25946aab5db44d2672521ec732e5dc9d1fd80c23bad38f0d7756ed"
    sha256 cellar: :any,                 arm64_monterey: "fc8542f6a694357798be7e2280be1bc66b1ced40692806638f2ac7fc699bf189"
    sha256 cellar: :any,                 arm64_big_sur:  "45e4d5e3f63678dfe1ae61c425a1f5b1e442644e04ec36e4d3ee13cf58ce6b13"
    sha256 cellar: :any,                 sonoma:         "5bc693e53a3a48a990482ba76ef8d512099f48959a9be934d31d0e63533068da"
    sha256 cellar: :any,                 ventura:        "9249cfa9a1cb2faa015c4b4d8c5a34e15d5d4c5623af8b5bd212b160f5b23869"
    sha256 cellar: :any,                 monterey:       "a06cbc49f0b79d5ce52875fbd2601e3e0acb1c4eec00b074d12809abc504e1e8"
    sha256 cellar: :any,                 big_sur:        "d06e787193c8f18a0696a64dbcb0a82ef7aeae666e2ef6b0470788ac0ebd65fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "48f8286f58619e5155092fe286194251c63398dbcc20bdfd17bfe6ac82b792ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "925189b43a69daaf38ec2011cdfa605d5f6f07aded7ca4828eb33570dee8f695"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sdl2"

  on_linux do
    depends_on "fontconfig"
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "openal-soft"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <stdlib.h>
      #include <Gosu/Gosu.hpp>

      class MyWindow : public Gosu::Window
      {
      public:
          MyWindow()
          :   Gosu::Window(640, 480)
          {
              set_caption("Hello World!");
          }

          void update()
          {
              exit(0);
          }
      };

      int main()
      {
          MyWindow window;
          window.show();
      }
    CPP

    system ENV.cxx, "test.cpp", "-o", "test", "-L#{lib}", "-lgosu", "-I#{include}", "-std=c++17"

    # Fails in Linux CI with "Could not initialize SDL Video: No available video device"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "./test"
  end
end
