class Corkscrew < Formula
  desc "Tunnel SSH through HTTP proxies"
  homepage "https://packages.debian.org/sid/corkscrew"
  url "https://deb.debian.org/debian/pool/main/c/corkscrew/corkscrew_3.1.orig.tar.gz"
  sha256 "0f9c62466b4cbb13e3384eda2e00eb5e793acf82a5c2980d81a334151d202255"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/c/corkscrew/"
    regex(/href=.*?corkscrew[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "62b0ee031c60f51caa016df4dcf6142422a3f1fe843c471fa9a509117db7f107"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8fb1637fe7c64ef0780be509b1882ef5607b92f5773a3cf0992455b4b8d6f7a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "60b43c6123028edd4951e90bbe16241142cfb4c84a2f2e4db96eef2d802d31b4"
    sha256 cellar: :any,                 arm64_linux:       "2885bc238c073fa4f35dfbee77d99715c78b9d38b2ec4f064f1c67b608472e69"
    sha256 cellar: :any,                 x86_64_linux:      "796908dd8289874d957995c0d749ce6f7a36abebb263029e07fb6cc084ecda22"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  allow_network_access! :test

  def install
    # Generated Autotools files are not shipped in the source tarball
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    port = free_port

    fork do
      server = TCPServer.new port
      socket = server.accept
      Open3.popen3("#{bin}/corkscrew 127.0.0.1 #{port} www.google.com 80") do |_, stdout, _|
        socket.write "GET /index.html HTTP/1.1\r\n\r\n"
        assert_match "HTTP/1.1", stdout.gets("\r\n\r\n")
      end
    end
  end
end
