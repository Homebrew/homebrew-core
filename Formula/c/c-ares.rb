class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.org/"
  url "https://github.com/c-ares/c-ares/releases/download/v1.33.0/c-ares-1.33.0.tar.gz"
  sha256 "3e41df2f172041eb4ecb754a464c11ccc5046b2a1c8b1d6a40dac45d3a3b2346"
  license "MIT"
  head "https://github.com/c-ares/c-ares.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?c-ares[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a58b7d447a4b9fb1d5ba0aa7dbcc32f54b0ddfa54ee28ad976f0f411a48e36af"
    sha256 cellar: :any,                 arm64_ventura:  "8b835e7eaa0f62a9238ff0faec52d40be1a6e699f6badb38581a0990f918e425"
    sha256 cellar: :any,                 arm64_monterey: "1d1a3ff3e65c1f79834a060f235d013e65dcd9b7c263c9405c304bb1f7b8105f"
    sha256 cellar: :any,                 sonoma:         "8e9e4fa3e7edb5fd9f738c03534fa38b8f7624340c5bd0df6c39ad0ef5edd2c1"
    sha256 cellar: :any,                 ventura:        "410fedce85a56aaca9e306e20a9ae23bb5df3b4c6baa7f311242fac405a19c4b"
    sha256 cellar: :any,                 monterey:       "78f7456f765929089a9c351fe9fbc336d7bc35d4d1f6fb46ea9cce7feb6edff9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c8d7b7dcdd36ed424e5e76b3b9f0666d18f7520b37e894af27b1389e3a75329"
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
