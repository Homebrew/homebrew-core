class Asio < Formula
  desc "Cross-platform C++ Library for asynchronous programming"
  homepage "https://think-async.com/Asio/"
  url "https://downloads.sourceforge.net/project/asio/asio/1.36.0%20%28Stable%29/asio-1.36.0.tar.bz2"
  sha256 "7bf4dbe3c1ccd9cc4c94e6e6be026dcc2110f9201d286bb9500dc85d69825524"
  license "BSL-1.0"

  livecheck do
    url :stable
    regex(%r{url=.*?Stable.*?/asio[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c270edee8c7f97079ae4f4cf2c6ea3f072a02e3966354fa233a72df2dff6834b"
    sha256 cellar: :any,                 arm64_sequoia: "701828b9474caf60d19e538ae4988a86d9df9a09ce95c9cf0e2de1cc8a6cbda6"
    sha256 cellar: :any,                 arm64_sonoma:  "acbee89e1effe0135dd01fec0bc94243cffbe5c2f5c7d5b0f7340428d9516dde"
    sha256 cellar: :any,                 arm64_ventura: "f6758226362135efb7485211bfe170ee4c3788c46a1275dca59c477ae8c6051c"
    sha256 cellar: :any,                 sonoma:        "6a4f0422454474b28955a8d9bb203d703bdbb7c857096dc32bd6c191fb8a0ba5"
    sha256 cellar: :any,                 ventura:       "0e1a5a2d7537a2ef0cd946cb75edcf3e72e615f78bc610f77987b0bacaad3231"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d1cda2230726d6339c1233ea2a126525d9044aacac103fb6da0fd195698a68b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b3a5307039ebc24abeba8e99bf96fdff91577b4d2a413715c3e83ff755c4ed4"
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
