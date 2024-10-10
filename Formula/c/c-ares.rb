class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.org/"
  url "https://github.com/c-ares/c-ares/releases/download/v1.34.0/c-ares-1.34.0.tar.gz"
  sha256 "c41715f12ed9163f387f16314b43bac2faca73018a0dce70ec291845d088f6f9"
  license "MIT"
  head "https://github.com/c-ares/c-ares.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?c-ares[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "fa10ad06a1e386de0ce7e772a327b782054c396fba4186bf03eeab00e3081574"
    sha256 cellar: :any,                 arm64_sonoma:   "1db3cc921cd4aace48310a4e0d7ad4a9804017f886fd73ad605203d0cc259395"
    sha256 cellar: :any,                 arm64_ventura:  "3d4e3e1b41a2c00478ed4ba32403cf5984a81dc067add57f6a7b7b029941ec6d"
    sha256 cellar: :any,                 arm64_monterey: "bb3bda7abb9fe1d9d4e5b955b20c3ed062c1eed3173664b6ce75adc99fe7b14c"
    sha256 cellar: :any,                 sonoma:         "d5898c8d8cba61d500fd9d443a80edea1ccb0f2385354cf7f06bbaf61d226693"
    sha256 cellar: :any,                 ventura:        "d188fcc5bd6ed8e5afa4bacc386778599d67aaecbeecd3c11eddd701fd92f42f"
    sha256 cellar: :any,                 monterey:       "3b06fda5ddf635bd903b1cae62b318bb5f0289da4f6f30448155970031a0d7bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef60b30007b92d22df5d8839d77cd88f35978e1436285a4f5e67a6990f822843"
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
