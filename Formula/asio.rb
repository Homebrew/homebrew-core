class Asio < Formula
  desc "Cross-platform C++ Library for asynchronous programming"
  homepage "https://think-async.com/Asio"
  url "https://downloads.sourceforge.net/project/asio/asio/1.28.0%20%28Stable%29/asio-1.28.0.tar.bz2"
  sha256 "d0ddc2361abd2f4c823e970aaf8e28b4b31ab21b1a68af16b114fc093661e232"
  license "BSL-1.0"

  livecheck do
    url :stable
    regex(%r{url=.*?Stable.*?/asio[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e695f3e1f6a2c96b7521a95695c0c6a306866c7e1aa4ba1764ae5a5836ee5bef"
    sha256 cellar: :any,                 arm64_monterey: "ee502f262978cef5ba9404c52ecf231840333f2afd108874f261ef1bf0522d09"
    sha256 cellar: :any,                 arm64_big_sur:  "1f783641073765794406635f67fef02fb3fa15d53616993c9b835689cc5a29a0"
    sha256 cellar: :any,                 ventura:        "4680b83b1ed3f45bf6178cbf183095cd73d51ab2576204d7a8a2d49ebc271169"
    sha256 cellar: :any,                 monterey:       "01ea2071f5d410cf6f3500dd0985cc6e08590d68b18c8a175e7ba307ec2bc7eb"
    sha256 cellar: :any,                 big_sur:        "84a0fea51a6b5324a47f5528aa54690693c49687378295ff4fe479a076c68aa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d73243892c6ae33a993184305b5b45a1611a68719e7ef8d6b587a60cbf8df4d"
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
