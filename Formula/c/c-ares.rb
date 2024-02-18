class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.org/"
  url "https://c-ares.org/download/c-ares-1.26.0.tar.gz"
  mirror "https://github.com/c-ares/c-ares/releases/download/cares-1_17_2/c-ares-1.26.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/dns/c-ares-1.26.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/dns/legacy/c-ares-1.26.0.tar.gz"
  sha256 "bed58c4f02b009080ebda6c2467ba469722ac6aebbf4497dc44a83d8c6194e50"
  license "MIT"
  head "https://github.com/c-ares/c-ares.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?c-ares[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "82239cfae6daeb2901576b33ee6b2c981814185b39687b978006ad3c5c27c210"
    sha256 cellar: :any,                 arm64_ventura:  "2ca73977aa22d003d664b40d8e9413cc2d046a724047034102c5264336df0bcc"
    sha256 cellar: :any,                 arm64_monterey: "da380915185db2ec25a4fd6c46fb6bf1869f9612951b8cfa62abff7f2f1f51fa"
    sha256 cellar: :any,                 sonoma:         "a5ec029a8dffbb63fc5ef7836cdd2ee7019dee86cd206d938421160c1070cca6"
    sha256 cellar: :any,                 ventura:        "2d1c526462d337ca825e7c77303fc0bdb78056c52a47e95db7d0bd8636445ac2"
    sha256 cellar: :any,                 monterey:       "3c69db33dde54de58f625a574c101def105132af34ebed6514af41a7c001abb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e279065210d7fa2165bc691edd7c5cdf0c286fa9089f8f80773bbd86f54d964f"
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
