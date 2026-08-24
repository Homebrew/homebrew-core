class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.org/"
  url "https://github.com/c-ares/c-ares/releases/download/v1.34.8/c-ares-1.34.8.tar.gz"
  sha256 "c222b6d681096f9444d2c4863d2c1174019e27cacca0a4a5c114d36dd7d7bf78"
  license "MIT"
  compatibility_version 1
  head "https://github.com/c-ares/c-ares.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?c-ares[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "44bcc2e67b97daa265e168281875129161ddbbc964ab16ec0db1846c289cc376"
    sha256 cellar: :any, arm64_sequoia: "cf56a78a008c16b5b430f5183178b644904fad00a55e6e57a20a835ecc45d33a"
    sha256 cellar: :any, arm64_sonoma:  "df0ce513f28c6a9b16077b89e8d5468603c9683b29bed4f1df7f76ad0af14930"
    sha256 cellar: :any, sonoma:        "38a79d86a4eeab5d3f1fdc017a6d4a1fc19c01d09c34f795f3bde6811eb5c1a5"
    sha256 cellar: :any, arm64_linux:   "475c140e774855ea0582294aef43ed073f1f09956d4919419dd2c01a8d2ed78d"
    sha256 cellar: :any, x86_64_linux:  "9225a94f66cf37b91f224c3e456d60fc59adfcfc9d28dd3c86966d1be3633687"
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
