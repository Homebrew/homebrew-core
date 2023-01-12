class Asio < Formula
  desc "Cross-platform C++ Library for asynchronous programming"
  homepage "https://think-async.com/Asio"
  url "https://downloads.sourceforge.net/project/asio/asio/1.26.0%20%28Stable%29/asio-1.26.0.tar.bz2"
  sha256 "858320108a0dfc6504cc1b3403182de8ccda1fb8f1c8a4e980e4cb03a11db34d"
  license "BSL-1.0"

  livecheck do
    url :stable
    regex(%r{url=.*?Stable.*?/asio[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f815e32780492160143522b116b345beb4dae7988740ff9bc15bbd555ffbf64e"
    sha256 cellar: :any,                 arm64_monterey: "5f1b6e7e92014c2968855a5983006934e57815f63675043e8c792b88dfea590a"
    sha256 cellar: :any,                 arm64_big_sur:  "a385f4e74d67b67faa71f638bf208be7d109128e9dea63dae154de736c0461ed"
    sha256 cellar: :any,                 ventura:        "5cbdd13ba307d9082cc2339a230fb3e3f78cdf294d1c9669def567c9ee37c5ac"
    sha256 cellar: :any,                 monterey:       "a8214e1e273449a9b22e71af97079246dcb2af34829695d964b92d3f226a22a1"
    sha256 cellar: :any,                 big_sur:        "ef7398e5c0bbd172fe30eaa3eb5abc648256d4391f8f69ec904ab01715b1d3f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "738a2a2bb835bc22296cbc88bdd1da28b6aa207175e2776697ff0e02a22e84ea"
  end

  head do
    url "https://github.com/chriskohlhoff/asio.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openssl@3"

  def install
    ENV.cxx11

    if build.head?
      cd "asio"
      system "./autogen.sh"
    end

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-boost=no",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}"
    system "make", "install"
    pkgshare.install "src/examples"
  end

  test do
    found = Dir[pkgshare/"examples/cpp{11,03}/http/server/http_server"]
    raise "no http_server example file found" if found.empty?

    port = free_port
    pid = fork do
      exec found.first, "127.0.0.1", port.to_s, "."
    end
    sleep 1
    begin
      assert_match "404 Not Found", shell_output("curl http://127.0.0.1:#{port}")
    ensure
      Process.kill 9, pid
    end
  end
end
