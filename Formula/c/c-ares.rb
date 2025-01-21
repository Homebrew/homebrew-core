class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.org/"
  url "https://github.com/c-ares/c-ares/releases/download/v1.34.4/c-ares-1.34.4.tar.gz"
  sha256 "fa38dbed659ee4cc5a32df5e27deda575fa6852c79a72ba1af85de35a6ae222f"
  license "MIT"
  head "https://github.com/c-ares/c-ares.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?c-ares[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1db34e25cf5af8441aa0cf479f1ca4330e031d2a35ed3b717563b1f1a1104cf4"
    sha256 cellar: :any,                 arm64_sonoma:  "93b4eabc07d647638e19c3293d52f803ce5b1ebf45b817525e6307241e790301"
    sha256 cellar: :any,                 arm64_ventura: "96657bac75a42089fdf829f450125b77c3cdb216a981a8350f4f06814f94983e"
    sha256 cellar: :any,                 sonoma:        "81825f7f6a7a5d3f449535c1fb6242a3372c435c93db3f042fae96d2c4abe119"
    sha256 cellar: :any,                 ventura:       "271f20135a100723f4138e3353cefd9509ce952d64c57c04feb2b20c306430f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ba26d45c3a98cf3a424b279be104e885005c31bca12f0d663e841d09ed4f6f4"
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
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <ares.h>

      int main()
      {
        ares_library_init(ARES_LIB_INIT_ALL);
        ares_library_cleanup();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lcares", "-o", "test"
    system "./test"

    system bin/"ahost", "127.0.0.1"
  end
end
