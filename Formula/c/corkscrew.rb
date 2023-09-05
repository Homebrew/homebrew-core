class Corkscrew < Formula
  desc "Tunnel SSH through HTTP proxies"
  homepage "https://packages.debian.org/sid/corkscrew"
  url "https://deb.debian.org/debian/pool/main/c/corkscrew/corkscrew_2.0.orig.tar.gz"
  sha256 "0d0fcbb41cba4a81c4ab494459472086f377f9edb78a2e2238ed19b58956b0be"
  license "GPL-2.0"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/c/corkscrew/"
    regex(/href=.*?corkscrew[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1bd52cc5c72e9ca3461dc63fdfb584ac3622a57effae88f14a8e7eab146a57b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1add42728d114c019b0621bbd8aa9f3f95c433e006f38bdba71d9387e667357"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7882ab8fa538eb9eee596f56fa6f65c14f1f3e467a822ce7a39ea197d2fe08a5"
    sha256 cellar: :any_skip_relocation, ventura:        "16b81ff2ca5d308f0eb953399f4ec771870ff1019d93b69630f1218fbd185dc5"
    sha256 cellar: :any_skip_relocation, monterey:       "51bb3c53d276f9abc51f7b6338ef96f3b2bd7686d8b331eb0ffdb52b51bdf9f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "af93a7005479f2004b385e484c633f42577d7cd99272d5e7ec4c17e3d0239a7b"
    sha256 cellar: :any_skip_relocation, catalina:       "83db433b1d34ad662d310504a476bcd5848955b0cc78087203b8e25164e4c8a8"
    sha256 cellar: :any_skip_relocation, mojave:         "c9a878e744506cee8a10b370ec59a2ebfb43b0a84c73ff02b67ba24f68c17938"
    sha256 cellar: :any_skip_relocation, high_sierra:    "53e2a491ecc6b1446ed3dcf1fc9a8c44ca9735acd9d0626e7806dc80b5285e79"
    sha256 cellar: :any_skip_relocation, sierra:         "85d9050689df4cf0ec3275957fad60609ea1a9511079f20f05470e1b767c94f2"
    sha256 cellar: :any_skip_relocation, el_capitan:     "f7e4e63df01aa33a6518f4f6c2c0ccbb0c7b8aaca95052d4aa827b5e56ed8e5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aad5bc0cad7686b7741300366d92107ed90c84eabc8868d309a2f61c96b3135d"
  end

  depends_on "libtool" => :build

  def install
    cp Dir["#{Formula["libtool"].opt_share}/libtool/*/config.{guess,sub}"], buildpath
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    require "open3"
    require "webrick"
    require "webrick/httpproxy"

    pid = fork do
      proxy = WEBrick::HTTPProxyServer.new Port: 8080
      proxy.start
    end

    sleep 1

    begin
      Open3.popen3("#{bin}/corkscrew 127.0.0.1 8080 www.google.com 80") do |stdin, stdout, _|
        stdin.write "GET /index.html HTTP/1.1\r\n\r\n"
        assert_match "HTTP/1.1", stdout.gets("\r\n\r\n")
      end
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
