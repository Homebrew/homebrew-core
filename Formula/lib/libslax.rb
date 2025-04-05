class Libslax < Formula
  desc "Implementation of the SLAX language (an XSLT alternative)"
  homepage "https://github.com/Juniper/libslax/wiki"
  url "https://github.com/Juniper/libslax/releases/download/3.1.0/libslax-3.1.0.tar.gz"
  sha256 "edf574ed4491b04181d29ff9153555f7605cb38cc9905dad767284403cfca780"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia:  "9a912d3e7a8335a0a88118983dae826c6a6342217fe4dcca0777e60b49c937b0"
    sha256 arm64_sonoma:   "702b5c70a2022383582b60356878b121b09e192f024ce03c88acd6d29c7f7e8f"
    sha256 arm64_ventura:  "fbcd1b639ddfc45b2dde2c0889a959fda82c0aedf88cbb7fcc7496c14cce0cef"
    sha256 arm64_monterey: "0777ecc30f69e7ae8a57c089b1fb6c36819c2781b62514faaa26949ba1ee6adf"
    sha256 arm64_big_sur:  "2e09965e5c95fe93264cce82f9d32a9a046d11fd787829830a41822f0a2d7120"
    sha256 sonoma:         "a0c440e3ff44959eccf1ffe8ffb9bf51bd5620279cc0a28d450bbc7af206091b"
    sha256 ventura:        "345525711533004f5390450cfc300552307bf0aeefbb940f69031099b10d8d12"
    sha256 monterey:       "c323e5e9423cd0201f46342bf7ce05c3e6623367f3f3f9f2db880a6fe59ccea3"
    sha256 big_sur:        "30ab59f88a09b6e5238585a3c00299733c721b6533355629e58a99275916fc25"
    sha256 x86_64_linux:   "433ed00d6104bc49ff4dc3bac740c7854e12e54d5c9f52c4db160f1673398f48"
  end

  head do
    url "https://github.com/Juniper/libslax.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "bison" => :build
  depends_on "libtool" => :build
  depends_on :macos # needs libxslt built --with-debugger
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "sqlite"

  conflicts_with "genometools", because: "both install `bin/gt`"
  conflicts_with "libxi", because: "both install `libxi.a`"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules", "--enable-libedit", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"hello.slax").write <<~EOS
      version 1.0;

      match / {
          expr "Hello World!";
      }
    EOS

    system bin/"slaxproc", "--slax-to-xslt", "hello.slax", "hello.xslt"
    assert_path_exists testpath/"hello.xslt"
    assert_match "<xsl:text>Hello World!</xsl:text>", File.read("hello.xslt")
  end
end
