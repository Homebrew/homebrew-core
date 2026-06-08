class EpollShim < Formula
  desc "Small epoll implementation using kqueue"
  homepage "https://github.com/jiixyj/epoll-shim"
  url "https://github.com/jiixyj/epoll-shim/archive/refs/tags/v0.0.20240608.tar.gz"
  sha256 "8f5125217e4a0eeb96ab01f9dfd56c38f85ac3e8f26ef2578e538e72e87862cb"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:    "c7a688d329d70d090603693a115882bbaa044defdc738f4efc52b1b7b451484b"
    sha256 cellar: :any, arm64_sequoia:  "06103b1d0768dffc87680b337dab8116c467315b734dd58de23401d21debb415"
    sha256 cellar: :any, arm64_sonoma:   "19f7863e77782dbf4c31bee8751899351ffd97063d0708510c211f594e403792"
    sha256 cellar: :any, arm64_ventura:  "3d8b019c172b7cf7d34ac0646da46474bbd51bfd488cad3d246080bcd561f550"
    sha256 cellar: :any, arm64_monterey: "25d8af50ea45fb417a802f4b837bceb296ee1a00ab642be73f636b30656a4182"
    sha256 cellar: :any, sonoma:         "ea3647d10920d14080e1267606b40e7dacb2390818f84076e84eb817a1a78d1b"
    sha256 cellar: :any, ventura:        "19a54dec59e5a92d900b6376b7e140af4e08af6343a3c762ea94364de222c97d"
    sha256 cellar: :any, monterey:       "ad0c5b28e749ebd570f59dd630db71ce9d45435a664e44b1e2c290602d66c0db"
  end

  depends_on "cmake" => :build

  depends_on :macos

  def install
    args = %W[
      -DCMAKE_INSTALL_PKGCONFIGDIR=#{lib}/pkgconfig
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <sys/epoll.h>

      #include <fcntl.h>
      #include <unistd.h>
      #include <stdlib.h>

      int main(void)
      {
        int ep = epoll_create1(EPOLL_CLOEXEC);
        if (ep < 0)
          abort();
        close(ep);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}/libepoll-shim", "-lepoll-shim"
    system "./a.out"
  end
end
