class Asio < Formula
  desc "Cross-platform C++ Library for asynchronous programming"
  homepage "https://think-async.com/Asio"
  url "https://downloads.sourceforge.net/project/asio/asio/1.28.1%20%28Stable%29/asio-1.28.1.tar.bz2"
  sha256 "3bcf0357e2e19a2ee5adc805e6cc209338a7461c406d3047d282ea1c4b566101"
  license "BSL-1.0"

  livecheck do
    url :stable
    regex(%r{url=.*?Stable.*?/asio[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0b7dcbce082652d8b7b437b0b5e4994731eee122de8d4438a14bb73516b8cfe6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "afee43084abe550b59253d8b05bfe2f4e9735bc8e8245067edae9ca5367e4d20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aadc88fbaac96e4886b9da1e2f5f3733c91d1c543430fdec047402c2a397665c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a729d67adbec19d0207de92fcbac2ab80264c6f50f3d57973bf585fdec5dff78"
    sha256 cellar: :any,                 sonoma:         "a6964537058ff70e97cdbcbc443b93a927c5d52b99d6dde5219d746bfa882cee"
    sha256 cellar: :any_skip_relocation, ventura:        "5bd3675a77ec2ad624ae08cd459d0d2008f27b4a150a30feaaf6c2fbd9bf1ea2"
    sha256 cellar: :any_skip_relocation, monterey:       "4beb25487b7e5548fc86d538b9a5e51de37540604a6ac71c6eecdff76d1bc1dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c26d0ed67f36c26a9204496b6b437917e470eba0a7c3132090b86c848de51c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef48e68516761c4d94b643b82cb54a9c018734aa4bca02449bef44a4cbcbae10"
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
