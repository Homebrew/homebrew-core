class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.org/"
  url "https://github.com/c-ares/c-ares/releases/download/v1.30.0/c-ares-1.30.0.tar.gz"
  sha256 "4fea312112021bcef081203b1ea020109842feb58cd8a36a3d3f7e0d8bc1138c"
  license "MIT"
  head "https://github.com/c-ares/c-ares.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?c-ares[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e304ec5f5386007c2554dbd3a92a1a340ca8d8fe84a0396dfc006694e6306ae8"
    sha256 cellar: :any,                 arm64_ventura:  "2afb25bfdcc6a91c1fc6fe7b576692ec67e12dc96ba561385e287861aee99a0b"
    sha256 cellar: :any,                 arm64_monterey: "f538ea0a8392e20cff0f3a3d9f7f56ba562b0ad57f68e4e9546ed8f3fd6dcc72"
    sha256 cellar: :any,                 sonoma:         "5a6aa951ec2048cea52b1b070d45f06cb831de561c8833e9dc20888afe7d8045"
    sha256 cellar: :any,                 ventura:        "e22da8c0e8dcf5b2c114b5d2be32b1a30ab632aeadc59fb3fc7ba4d1f3e90c15"
    sha256 cellar: :any,                 monterey:       "87b091b809c673b125927e4e318d4e6749bb0e558269ab5d1dfcb2385c50bbdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "999cd2bf4b15f8f00ec70bbaae381b9b89d5cd338de46d3150fdea1197c3ba36"
  end

  depends_on "cmake" => :build

  def install
    args = %W[
      -DCARES_STATIC=ON
      -DCARES_SHARED=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <ares.h>

      int main()
      {
        ares_library_init(ARES_LIB_INIT_ALL);
        ares_library_cleanup();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lcares", "-o", "test"
    system "./test"

    system bin/"ahost", "127.0.0.1"
  end
end
