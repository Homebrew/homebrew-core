class Proxytunnel < Formula
  desc "Create TCP tunnels through HTTPS proxies"
  homepage "https://github.com/proxytunnel/proxytunnel"
  url "https://github.com/proxytunnel/proxytunnel/archive/v1.10.20210604.tar.gz"
  sha256 "47b7ef7acd36881744db233837e7e6be3ad38e45dc49d2488934882fa2c591c3"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "65570cf9f771e78f7c3a08c88630fc5af7100df0025ff1c35286306735e37a40"
    sha256 cellar: :any,                 arm64_big_sur:  "97ccd9b616094e055755979daed8216f418d2aeb4639cf978b5df289d1c7e4ea"
    sha256 cellar: :any,                 monterey:       "c3058d31c2f16a210b122115dfdfa5e29a36905185a505abeb4e9f02d04b9d09"
    sha256 cellar: :any,                 big_sur:        "88027c4126895fb5c1f25b1045df6bd3e79dd9d4c3e0e7c9623c0538f72d0df7"
    sha256 cellar: :any,                 catalina:       "b69ed34113341b0c25778b0b10af2079d17e32e2f7288fa2feed80677124ec15"
    sha256 cellar: :any,                 mojave:         "9f941a568397ae9ec164cde36aaafe90237f36b516e1403985e10687601cf15a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f65fb0bf533922b366e1c60989fd0db345afdf7769eb88ae6bdb9aaa5833d482"
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
