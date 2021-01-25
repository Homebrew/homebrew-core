class Proxytunnel < Formula
  desc "Create TCP tunnels through HTTPS proxies"
  homepage "https://github.com/proxytunnel/proxytunnel"
  url "https://github.com/proxytunnel/proxytunnel/archive/v1.10.20200907.tar.gz"
  sha256 "b8740375c4f0f635fd22b197389d4268daeb70829648e15050fd4db2b41ef898"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any
    sha256 "3f06eb49b8c96b0e61876e08198fb5ab21e70b8b211c07cc23d8ece0d5249946" => :big_sur
    sha256 "cd68d6b05ad6b3f2a5f2fdeb030ab14b80858dddcd5f9c74f40c72443700dc02" => :arm64_big_sur
    sha256 "18a5771a429cb73cc2f8de55c44ba2ba061238157458533302b5d609478039c7" => :catalina
    sha256 "257d06dda3279ca934dead8774ac3800bf97404af51d5fbfda7fba4ec99ce36c" => :mojave
    sha256 "46362f2b3cd8118b315e5eaae4c0fd5e391a2c741399f33c772cac3992221846" => :high_sierra
  end

  depends_on "asciidoc" => :build
  depends_on "xmlto" => :build
  depends_on "openssl@1.1"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/proxytunnel", "--version"
  end
end
