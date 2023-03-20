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
    sha256 cellar: :any,                 arm64_ventura:  "a4c16df47b5b0e4e272cc4d3e5a59145dc1b11b031ffbd5daeda8e1e89317bbf"
    sha256 cellar: :any,                 arm64_monterey: "204cf96a34629195e3f09f9c1e4b2e896f76a75207122cdb09447e7f66d00ed2"
    sha256 cellar: :any,                 arm64_big_sur:  "7f81d62e95806c35522ff629c2145721c43efc7605f8e2d2403342150865830a"
    sha256 cellar: :any,                 ventura:        "9e6e8e7be0a34b9de9769a881fc79ea4668092f2e9183d3622ea3fe66ddf5531"
    sha256 cellar: :any,                 monterey:       "824e821c1147439f8a9fc22301dab82a4603198f1f5907d804b41fa717c16ca6"
    sha256 cellar: :any,                 big_sur:        "eb3bacc9a7ce9079fcc4f6d17ecf9af340765aae1c5d45b57fa68deed3222226"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45090f28798a426d6cbd2e822387a947878ce84a57713f464dde336c89f02a7f"
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
