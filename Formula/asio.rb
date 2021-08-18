class Asio < Formula
  desc "Cross-platform C++ Library for asynchronous programming"
  homepage "https://think-async.com/Asio"
  url "https://downloads.sourceforge.net/project/asio/asio/1.18.2%20%28Stable%29/asio-1.18.2.tar.bz2"
  sha256 "3ac05d4586d4b10afc28ff09017639652fb04feb9e575f9d48410db3ab27f9f2"
  license "BSL-1.0"
  head "https://github.com/chriskohlhoff/asio.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?Stable.*?/asio[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "11ab7bb26a9782754a8c872dac4b9cc4c5205fc34061a4678a3eed6d173ab06a"
    sha256 cellar: :any,                 big_sur:       "c51769f155b21a0c7c82862c25ece1d40e79fc7db7b919c7daa5437e4060ad85"
    sha256 cellar: :any,                 catalina:      "e3fe0bf41ab84047722cb2936c604b13be10723f9a98f006e21db27d82c38d35"
    sha256 cellar: :any,                 mojave:        "2f2769fda61b376035b53a8da40860b80566a7725ef294312d4d415ae5aae5e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a62b72aee8a6bbc417749b3fa18196017b8de57b84705098d4ebba1c34925eef"
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
      Process.wait pid
    end
  end
end
