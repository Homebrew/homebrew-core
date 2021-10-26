class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.org/"
  url "https://c-ares.org/download/c-ares-1.18.0.tar.gz"
  mirror "https://github.com/c-ares/c-ares/releases/download/cares-1_17_2/c-ares-1.18.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/dns/c-ares-1.18.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/dns/legacy/c-ares-1.18.0.tar.gz"
  sha256 "71c19708ed52a60ec6f14a4a48527187619d136e6199683e77832c394b0b0af8"
  license "MIT"
  head "https://github.com/c-ares/c-ares.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?c-ares[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "4b3f66b638dbcbe79f4f4501ea18d8ab8ece1c456dd4224abc832c840b58d25c"
    sha256 cellar: :any,                 big_sur:       "18830bd78ca245d689bab0c1e339565d285135172524142a316eda0ba278bf52"
    sha256 cellar: :any,                 catalina:      "50099cd3d317f25932825dec6683b539ceec5c73078b9933819cc9e005dd9952"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68029f1953a85a50394d2a1501aeb07f744281cfb669feaf99b0d0a5b233fa7e"
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
