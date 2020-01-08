class Corkscrew < Formula
  desc "Tunnel SSH through HTTP proxies"
  homepage "https://packages.debian.org/sid/corkscrew"
  url "https://deb.debian.org/debian/pool/main/c/corkscrew/corkscrew_2.0.orig.tar.gz"
  sha256 "0d0fcbb41cba4a81c4ab494459472086f377f9edb78a2e2238ed19b58956b0be"

  bottle do
    cellar :any_skip_relocation
    sha256 "83db433b1d34ad662d310504a476bcd5848955b0cc78087203b8e25164e4c8a8" => :catalina
    sha256 "c9a878e744506cee8a10b370ec59a2ebfb43b0a84c73ff02b67ba24f68c17938" => :mojave
    sha256 "53e2a491ecc6b1446ed3dcf1fc9a8c44ca9735acd9d0626e7806dc80b5285e79" => :high_sierra
    sha256 "85d9050689df4cf0ec3275957fad60609ea1a9511079f20f05470e1b767c94f2" => :sierra
    sha256 "f7e4e63df01aa33a6518f4f6c2c0ccbb0c7b8aaca95052d4aa827b5e56ed8e5c" => :el_capitan
    sha256 "5a0916aa242a22808bbbb652664f1e44620c1c78b896982f67c9a5a1b85a5efc" => :yosemite
    sha256 "79ca3f19c2a8df1cd7b43410ab600d32c4fc7038f99998acb656e5cc61807f25" => :mavericks
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
      proxy = WEBrick::HTTPProxyServer.new :Port => 8080
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
