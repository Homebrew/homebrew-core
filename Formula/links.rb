class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.24.tar.bz2"
  sha256 "9b12f5ba2d068306d7ff7385b520cdcafdc0e55c87eec877abb0e78288525430"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://links.twibright.com/download.php"
    regex(/Current version is v?(\d+(?:\.\d+)+)\. /i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "94b8d45a8156a3fb2bb1efdd25d78017e312cfeff0d2d29b3e60858ab5a7c40b"
    sha256 cellar: :any,                 big_sur:       "ddca13a7d919ab86834c886f684cda50180bc2fb5db81ba3daddcbc25651ec3c"
    sha256 cellar: :any,                 catalina:      "08b0f5fb8b0e04fa88b5617ec518032c43ee5b13c797e908bdf6a3543e2d5fdc"
    sha256 cellar: :any,                 mojave:        "31cf4aa8a7e783e6274e9f4dff60dcacacc7977208631fc7fe8b7723373ab351"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "774973bfb7f502c96631653112854bb513f9620e8cf56a9a7f4a92583080c827"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "openssl@1.1"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
      --without-lzma
    ]

    system "./configure", *args
    system "make", "install"
    doc.install Dir["doc/*"]
  end

  test do
    system bin/"links", "-dump", "https://duckduckgo.com"
  end
end
