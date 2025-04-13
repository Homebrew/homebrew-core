class Asio < Formula
  desc "Cross-platform C++ Library for asynchronous programming"
  homepage "https://think-async.com/Asio/"
  url "https://downloads.sourceforge.net/project/asio/asio/1.34.2%20%28Stable%29/asio-1.34.2.tar.bz2"
  sha256 "9cbe5e8abefcde3cb2705672210548a3e9e82b13682a3d2828bc34d3fe1b5583"
  license "BSL-1.0"

  livecheck do
    url :stable
    regex(%r{url=.*?Stable.*?/asio[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c0fd0028dff865ae4e273649efbe66a58c4ffd855921afd1b785fbd38edc1cde"
    sha256 cellar: :any,                 arm64_sonoma:  "5f74987c52a3a1421b1b8a34e5e47dd6d3503c622fd6ec0c034a49b84a80f2ed"
    sha256 cellar: :any,                 arm64_ventura: "377cba01eeb059795fc12a050252d7eb162b83111ccd00524ab6ae7202747589"
    sha256 cellar: :any,                 sonoma:        "9ea1ed483f0d26028a0f0b47b76c6895bec9c46efc43e40dd45d9122e948223d"
    sha256 cellar: :any,                 ventura:       "538de15b7a51d592382ab09eb7f0841254920888d67501b46d5cf07496c7378b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "542054da8a5f17cf65ffa78c35cc4a3e3163086fe380e2021fc6bd1639b132dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d415a556ecfdaf641d8cfb8a5dfe6a6453f0a016f03af7362e1b6573a4557cd2"
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
