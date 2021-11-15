class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.org/"
  url "https://c-ares.org/download/c-ares-1.18.1.tar.gz"
  mirror "https://github.com/c-ares/c-ares/releases/download/cares-1_17_2/c-ares-1.18.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/dns/c-ares-1.18.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/dns/legacy/c-ares-1.18.1.tar.gz"
  sha256 "1a7d52a8a84a9fbffb1be9133c0f6e17217d91ea5a6fa61f6b4729cda78ebbcf"
  license "MIT"
  head "https://github.com/c-ares/c-ares.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?c-ares[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7b1eacc9efbe8ac32a4a7cdb705fe5b3e637237cdd0ee67ce9a97c36c02ed99d"
    sha256 cellar: :any,                 arm64_big_sur:  "555cf945221fc8f076919a16e07541a37841bfc63ed2c58e24311f93ac2f2af6"
    sha256 cellar: :any,                 monterey:       "ab68d14a31625efd1c9289d976a041f4a0b573eeaa623d0d2e2889d36c388ffa"
    sha256 cellar: :any,                 big_sur:        "d3dd43338a6003320bfc94466887a2336f2a8bb36091326689828dc8a96194e2"
    sha256 cellar: :any,                 catalina:       "cb7b2f185a1c9e550e0ac6b6e48cca0f521ecf70bee3f04a3e5a878c63d3bb6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26c1f594d87832209d59cfcd1d635d9d7ee33c1c11ae31e377c92be1483f08c4"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
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
  end
end
