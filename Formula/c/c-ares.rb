class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.org/"
  url "https://c-ares.org/download/c-ares-1.27.0.tar.gz"
  mirror "https://github.com/c-ares/c-ares/releases/download/cares-1_17_2/c-ares-1.27.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/dns/c-ares-1.27.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/dns/legacy/c-ares-1.27.0.tar.gz"
  sha256 "0a72be66959955c43e2af2fbd03418e82a2bd5464604ec9a62147e37aceb420b"
  license "MIT"
  head "https://github.com/c-ares/c-ares.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?c-ares[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cb6e89367f33ccd46b0971724c9663f329a07d9de4436d645d3240a576a9b469"
    sha256 cellar: :any,                 arm64_ventura:  "5b25397a778fc3996f862a159706ce26bc77b955cb1be9cc5137246c6706fd41"
    sha256 cellar: :any,                 arm64_monterey: "df3766554aa5c0ff8188c0d0f5c6089be8a2d6b7e30e83faa5c86cdc899c5ab1"
    sha256 cellar: :any,                 sonoma:         "f6bbe3e31ae934008ea920122e6f59c8d32c9ed43a4c35993ae1b4d800531f9c"
    sha256 cellar: :any,                 ventura:        "c57f3b18d6b79aa8cb741a22ae202aa3a2958c6f496d119369ec2db52cbc09f2"
    sha256 cellar: :any,                 monterey:       "019543e83412dbdb914151cb80996578256026a380e953d214e92fc872a6c9a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01174930e8f1a7aaee38aa447ae587fd5d62575c224787e26e68996a72fc51a4"
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
