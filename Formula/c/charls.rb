class Charls < Formula
  desc "C++ JPEG-LS library implementation"
  homepage "https://github.com/team-charls/charls"
  url "https://github.com/team-charls/charls/archive/refs/tags/2.4.2.tar.gz"
  sha256 "d1c2c35664976f1e43fec7764d72755e6a50a80f38eca70fcc7553cad4fe19d9"
  license "BSD-3-Clause"
  head "https://github.com/team-charls/charls.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "a1c092740b2d8128a1c4bfe89a332c4bc132a936a6f058d34af8470c465d429c"
    sha256 cellar: :any,                 arm64_sequoia:  "4c5a430f93616eee0bbf2464f5b950ebced3874e71fe95dd8c50c78d30752af8"
    sha256 cellar: :any,                 arm64_sonoma:   "76dca903581c658d0db0f4f7102cf6f766def35e259b8f5fd1b7b215f294b684"
    sha256 cellar: :any,                 arm64_ventura:  "2472b5bdd282eb272b5f83b1e09fac00a4285802abf5215a08af4b6e2d8a2f6a"
    sha256 cellar: :any,                 arm64_monterey: "e0ee8a676b172678dd39668e90fa18b348c3cdd3415e1e6d0aee0aa8cae7f7ba"
    sha256 cellar: :any,                 arm64_big_sur:  "b0cf01cbfa53eacc7cfee7771face7e9b1627f3e9b648fe0ef797b900e4f1a36"
    sha256 cellar: :any,                 sonoma:         "b2f37034db31c89e31bcbabfab4daff049e26f37ccaadf8ccbba0ba261ac029e"
    sha256 cellar: :any,                 ventura:        "2c5587e6cc5f98c3fde8baee24ddda28bcf57fea3823ad50b8a723bccd2d92ed"
    sha256 cellar: :any,                 monterey:       "d7b1f60902af614082b112fb145a04cbe2ee474867a9ac0a5e6311e7763b406e"
    sha256 cellar: :any,                 big_sur:        "6d5ed0ccde713e3301144a103d26aadc8b5e737800536c68cb1b53ba992ffb34"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7a1ff310d136b6dcce83438562977bd6ea391e315eb9eb066bbd62fbab5cc5dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c047efbbea396272b84c00659b8f68a03b7130c19b1835f9f83c5be28351a7e5"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DCHARLS_BUILD_TESTS=OFF
      -DCHARLS_BUILD_FUZZ_TEST=OFF
      -DCHARLS_BUILD_SAMPLES=OFF
      -DBUILD_SHARED_LIBS=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <charls/charls.h>
      #include <iostream>

      int main() {
        charls::jpegls_encoder encoder;
        std::cout << "ok" << std::endl;
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++14", "-I#{include}", "-L#{lib}", "-lcharls", "-o", "test"
    assert_equal "ok", shell_output(testpath/"test").chomp
  end
end
