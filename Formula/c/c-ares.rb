class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.org/"
  url "https://c-ares.org/download/c-ares-1.24.0.tar.gz"
  mirror "https://github.com/c-ares/c-ares/releases/download/cares-1_17_2/c-ares-1.24.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/dns/c-ares-1.24.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/dns/legacy/c-ares-1.24.0.tar.gz"
  sha256 "c517de6d5ac9cd55a9b72c1541c3e25b84588421817b5f092850ac09a8df5103"
  license "MIT"
  head "https://github.com/c-ares/c-ares.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?c-ares[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f9345a17bd9555ceb70b9c2ec186042a06ec4269fe7ddd07eda1bfd0a048cc8d"
    sha256 cellar: :any,                 arm64_ventura:  "2e099330f8027783e7556853a29db75b01e2c01d9ed03287d18225c2033f625b"
    sha256 cellar: :any,                 arm64_monterey: "b14712164c85ab07dcae91a19dc4b2914635ea633ccfd837d419a6610ad1cebe"
    sha256 cellar: :any,                 sonoma:         "08c89c93f07e2856aace4fa1a851bf52b5b4200bb8993559ad04121164714cb4"
    sha256 cellar: :any,                 ventura:        "4e3f29d9e53f60402920af4d00091d1294f1443fc0b76c4b5bdee21011526005"
    sha256 cellar: :any,                 monterey:       "9b1db321f720acdaa970a629ef6b086bd5e75a88fcaae8af80d670338a8b62f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0247b5008e5f2415cff30024616f32a99ade43fa3f58477e0893dfaa26210d9a"
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

    system "#{bin}/ahost", "127.0.0.1"
  end
end
