class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.28.tar.bz2"
  sha256 "2fd5499b13dee59457c132c167b8495c40deda75389489c6cccb683193f454b4"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://links.twibright.com/download.php"
    regex(/Current version is v?(\d+(?:\.\d+)+)\. /i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9134a7e5e486104e6ef5fe33c99626fb76808a2489fb27ca3551f8156e8af4d5"
    sha256 cellar: :any,                 arm64_big_sur:  "cb3dfd4ac4f8a77497165549502b43df2f536404ca7ac7156a04a243a85ba81e"
    sha256 cellar: :any,                 monterey:       "da28f8a6a32397f1a1c94a8e1bb3b24fb1b6cc65ca7d812b8691ffd578ceea5f"
    sha256 cellar: :any,                 big_sur:        "ab0b2649920041bce1e11a68043fff87bd65c02e19f80515282086cc4ef63bf9"
    sha256 cellar: :any,                 catalina:       "702d2d5103b0665285e5d55e2052360e23809de7d16f07842ddb4031e9a219af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c4ae58d62709d6ec257b13c6b43c57066c03ec6b5422d13afd16779d4a008d1"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args,
                          "--mandir=#{man}",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--without-lzma"
    system "make", "install"
    doc.install Dir["doc/*"]
  end

  test do
    system bin/"links", "-dump", "https://duckduckgo.com"
  end
end
