class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.org/"
  url "https://c-ares.org/download/c-ares-1.20.1.tar.gz"
  mirror "https://github.com/c-ares/c-ares/releases/download/cares-1_17_2/c-ares-1.20.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/dns/c-ares-1.20.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/dns/legacy/c-ares-1.20.1.tar.gz"
  sha256 "de24a314844cb157909730828560628704f4f896d167dd7da0fa2fb93ea18b10"
  license "MIT"
  head "https://github.com/c-ares/c-ares.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?c-ares[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "81f08757c7bc31cd7c7d2051df0fb0c27b48ee2b36379afae28e706adf2ce07d"
    sha256 cellar: :any,                 arm64_ventura:  "c4c691f0df9857f0864330416c17b21954895207f4f0ad259145094b47aceee0"
    sha256 cellar: :any,                 arm64_monterey: "da1c903d162efe06724116d24ee5aa0da384f332d63decfb88e5f089325ff8b1"
    sha256 cellar: :any,                 sonoma:         "5d4e46a5d1bedf2de6fb39fe1f9087bf59649511c5afe6054f48b858437fc365"
    sha256 cellar: :any,                 ventura:        "0da5674e27d885db0fad5ecf47e1410e2584c9dbbc88efedc08b90bb0c035924"
    sha256 cellar: :any,                 monterey:       "5b0e0a93c240f8ca1aa3ccf0a7139ab0d1b8c81c2c670953ad05e8786eb1b286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb67a4010483bebd0536293a3955475d785f3b51468a7d19ab8e03174bdaddb7"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
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

    system "#{bin}/ahost", "127.0.0.1"
  end
end
