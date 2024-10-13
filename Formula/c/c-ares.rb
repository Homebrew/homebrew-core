class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.org/"
  url "https://github.com/c-ares/c-ares/releases/download/v1.34.1/c-ares-1.34.1.tar.gz"
  sha256 "7e846f1742ab5998aced36d170408557de5292b92ec404fb0f7422f946d60103"
  license "MIT"
  head "https://github.com/c-ares/c-ares.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?c-ares[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "161b04a451366c85839df81acc2bd8c6c07559d3e246e104a529efe282c4a227"
    sha256 cellar: :any,                 arm64_sonoma:  "4f001432054d130d08812c48952c74ef81a0c8e1baa04d4fb4a3149208d851a6"
    sha256 cellar: :any,                 arm64_ventura: "73ac32cb2326b1e74ada255f2965293b86779bd5d2c0651968a3f982a74a2d88"
    sha256 cellar: :any,                 sonoma:        "e6ec6ba976280323c5201481ca2fcc9e8535203d0172726e3220e212a3e8e00e"
    sha256 cellar: :any,                 ventura:       "8725e27800c3245ca2199b373380279357ec1c69e77c8b7f81dc0af533725b48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f58f73ffc8a695572e14f7bfdde2afadc21f9dcc13f6b638f8fee040532765cb"
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
