class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.19.tar.bz2"
  sha256 "70758c7dd9bb70f045407900e0a90f1114947fce832c2f9bdefd5c0158089a0a"
  revision 1

  bottle do
    cellar :any
    sha256 "05eec8b900896aa68276828e3f03dc9d3877250e7a678ebde34a5cd9282027d4" => :mojave
    sha256 "09445c5dbb1365ea992ef378721bff650e3633fd00355893d68a5d6d26a4bb1b" => :high_sierra
    sha256 "7855d152526f394ee3e4b09a9dc4b9443f1c79c4738504a05df814248a844c28" => :sierra
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
