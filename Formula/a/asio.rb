class Asio < Formula
  desc "Cross-platform C++ Library for asynchronous programming"
  homepage "https://think-async.com/Asio/"
  url "https://downloads.sourceforge.net/project/asio/asio/1.38.2%20%28Stable%29/asio-1.38.2.tar.bz2"
  sha256 "c04e0e66ac29741faad763a56f3c50196421d4b968009fc237c53314769bf8ad"
  license "BSL-1.0"
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{url=.*?Stable.*?/asio[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2c3d2fd827beb61e9e7e9b90b973d7ccf03a530477552a5f165568f13b52bc4f"
    sha256 cellar: :any, arm64_sequoia: "bd5a90a612ca0d8f81a18e1d0dac9368a560e264ce686bc0013779d7773db33f"
    sha256 cellar: :any, arm64_sonoma:  "1c44730757a01c8115fa24b97fa428978292a31a305f42a884559c0b2f8ab6ed"
    sha256 cellar: :any, sonoma:        "7168ed026aadfa0727b89369fc5ea942dac7a3eeeab41cc8c477711065b9efd1"
    sha256 cellar: :any, arm64_linux:   "bab4ec7e347864d62bb6350097c77b5663a620bb8b21df0f5eddb67a5e5e2b59"
    sha256 cellar: :any, x86_64_linux:  "cf4d50d55bc680c3460d21437c55194c37a620a1cc930ad85f6b0e31bd92158b"
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

    system "./configure", "--disable-silent-rules",
                          "--without-boost",
                          "--with-openssl=#{formula_opt_prefix("openssl@3")}",
                          *std_configure_args
    system "make", "install"
    pkgshare.install "src/examples"
  end

  test do
    found = Dir[pkgshare/"examples/cpp{11,03}/http/server/http_server"]
    raise "no http_server example file found" if found.empty?

    port = free_port
    pid = spawn found.first, "127.0.0.1", port.to_s, "."
    begin
      sleep 5
      assert_match "404 Not Found", shell_output("curl http://127.0.0.1:#{port}")
    ensure
      Process.kill 9, pid
    end
  end
end
