class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.16.29.tar.gz"
  sha256 "768beab0a37cf7a608bea4b5a73d07bc27e4f7e1429c566987680e5a8ca4bf43"
  license "GPL-2.0-or-later"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "1c36ae0fc0e389e607026e59eacc273f4620d5276a19f055dbb6ae8b79ec36bf"
    sha256 cellar: :any, arm64_golden_gate: "dbab7c5dd132524933c8d79a21bc9ba3a52f201502d273676a2a9c306346ea62"
    sha256 cellar: :any, arm64_tahoe:       "7e4504f9a86eb0199ae34cf0e59c8999bf0d40752e8de729bb52b03b1a38145b"
    sha256 cellar: :any, arm64_sequoia:     "0cd9f2e20bbafb17f3c1bbec4a0bfd2bd036ff42d3aaf2cb1fd71cbed2079e44"
    sha256 cellar: :any, arm64_linux:       "0ff8a5a0bc5cca774572a48b16e2b69e7208824c0d0c850e70fcf6a43ae9dc86"
    sha256 cellar: :any, x86_64_linux:      "87a0fbba5ba294ce51fb6f9f3bd19bdfc9cdd06c35a186cbcc4fb866a21100c6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "libtorrent-rasterbar", because: "both use the same libname"

  deny_network_access!

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <torrent/runtime/runtime.h>
      int main(void)
      {
        std::cout << torrent::runtime::version() << std::endl;
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-L#{lib}", "-ltorrent"
    assert_match version.to_s, shell_output("./test").strip
  end
end
