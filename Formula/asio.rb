class Asio < Formula
  desc "Cross-platform C++ Library for asynchronous programming"
  homepage "https://think-async.com/Asio"
  url "https://downloads.sourceforge.net/project/asio/asio/1.24.0%20%28Stable%29/asio-1.24.0.tar.bz2"
  sha256 "8976812c24a118600f6fcf071a20606630a69afe4c0abee3b0dea528e682c585"
  license "BSL-1.0"
  head "https://github.com/chriskohlhoff/asio.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?Stable.*?/asio[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ad623954bd7b57ecca1e10a016d908348648d66226721f05dbf7e9cc0e5663ea"
    sha256 cellar: :any,                 arm64_monterey: "e20aec9f064477c73792f6803c8e10e26c4cd4ce054b0ce459d6772368921689"
    sha256 cellar: :any,                 arm64_big_sur:  "a6f2e2deeac5cd08a04b2bee1c526e8edc7c47f32303224ab1071471ed7e0d77"
    sha256 cellar: :any,                 ventura:        "19eb60a2e7147cd9a7f45411a1f093adecd7bd244ae812891ade850e65f2a0e2"
    sha256 cellar: :any,                 monterey:       "129fd9c1da610fec3a7a3a2fe12826f627528e105de614af9ca5d52d50a80f2e"
    sha256 cellar: :any,                 big_sur:        "23ec57ee734521b53c0180751aacf12c44bf81f23767683a194afffd07dd295d"
    sha256 cellar: :any,                 catalina:       "b8d84401529dd7156387686e552f267474cdebda31786f78320de6e6f6aa5b6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ad1851fe6c46fa7440e78f0572eb23698fded2b1d80795a7558126ab7c740da"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openssl@1.1"

  def install
    ENV.cxx11

    if build.head?
      cd "asio"
      system "./autogen.sh"
    else
      system "autoconf"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost=no"
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
