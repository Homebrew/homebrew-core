class Asio < Formula
  desc "Cross-platform C++ Library for asynchronous programming"
  homepage "https://think-async.com/Asio"
  url "https://downloads.sourceforge.net/project/asio/asio/1.30.2%20%28Stable%29/asio-1.30.2.tar.bz2"
  sha256 "9f12cef05c0477eace9c68ccabd19f9e3a04b875d4768c323714cbd3a5fa3c2b"
  license "BSL-1.0"

  livecheck do
    url :stable
    regex(%r{url=.*?Stable.*?/asio[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "8c235792e528e6a97c2973ab94be18a14911e7af9280ba1436e8a4685a015483"
    sha256 cellar: :any,                 arm64_sonoma:   "8904055a14a4247b64b0b0109092dc16ec9b041a80b5575d41b19f4f68fa948d"
    sha256 cellar: :any,                 arm64_ventura:  "5f54e51a9617b78d98d5460432535ddbedd49c4f0a06b5674e9b4f4c4ccca2d5"
    sha256 cellar: :any,                 arm64_monterey: "671a310b49125e7690a9d3a5c11b98497b38146c59cc4d102addbc854e766b51"
    sha256 cellar: :any,                 sonoma:         "bf8e8eb31835f402abf69def9a391124c99f344117a0c6412d355e8a92681bb9"
    sha256 cellar: :any,                 ventura:        "45e09606350054371499f004e2c103222ad54c0d5e424cdcc066944817d62c26"
    sha256 cellar: :any,                 monterey:       "8e5c462f8c024efc16d037f57693465de5dd30523ef63f00309410d1dfe13d54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "327a7b1dadeaf5971516e58b9d7009e9004ffe198cd6621749d6836e604ff257"
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
    sleep 5
    begin
      assert_match "404 Not Found", shell_output("curl http://127.0.0.1:#{port}")
    ensure
      Process.kill 9, pid
    end
  end
end
