class Libcaption < Formula
  desc "Free open-source CEA608 / CEA708 closed-caption encoder/decoder"
  homepage "https://github.com/szatmary/libcaption"
  url "https://github.com/szatmary/libcaption/archive/refs/tags/v0.8.tar.gz"
  sha256 "8567765a457de43a6e834502cf42fd0622901428d9820c73495df275e01cb904"
  license "MIT"
  head "https://github.com/szatmary/libcaption.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "6b01b50b312db2c4a258c41771e39ae602a435307d50f039271db16dde82edc6"
    sha256 cellar: :any,                 arm64_sequoia: "3caa51dc2443e50903bce510871e2b444a4210f4ead10eb695c85595fdcc0a6a"
    sha256 cellar: :any,                 arm64_sonoma:  "24753a2f8bb14c9656297ac1076355b453cd25d15b5c232cd19d0284fe3779de"
    sha256 cellar: :any,                 arm64_ventura: "0b05cc4c507fdc95934508289869032a6e6659ded4443ba327a69d0e7e50361d"
    sha256 cellar: :any,                 sonoma:        "fd88c25e69d6d19bf148e4dfa9e011c7e4d9cc3137191689b9e8562f76a23762"
    sha256 cellar: :any,                 ventura:       "69ed641816398475080cbf5358a1daca18def0ae12fa5a96e0cd193f17f73483"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56f5a140b1213e982ebaad543a9c74e2f525aa8758e59afd6eff40a2c0f6a2cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a72274f3dd06de2c7d89616f06ebd6d4bff01e5caeea26d66662227bffdb2120"
  end

  depends_on "cmake" => :build

  def install
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_EXAMPLES=OFF",
                    "-DCMAKE_POSITION_INDEPENDENT_CODE=ON",
                    "-DBUILD_SHARED_LIBS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <caption/cea708.h>
      int main(void) {
        caption_frame_t ccframe;
        caption_frame_init(&ccframe);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcaption", "-o", "test"
    system "./test"
  end
end
