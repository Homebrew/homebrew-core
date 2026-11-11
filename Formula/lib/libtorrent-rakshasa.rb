class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.16.28.tar.gz"
  sha256 "2957ac68b8450fb78220b05ab17facfc1f6baa25d820182eeb4baa3db740cdc8"
  license "GPL-2.0-or-later"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ceec7b50ab148246fa29729445f7fa963fdc2c26fa08db2188a72cea60c17a2b"
    sha256 cellar: :any, arm64_tahoe:       "28a6c4dcf7d195014a025851e45c7d2834701ab7b3d89cb5ca5ceef987297e46"
    sha256 cellar: :any, arm64_sequoia:     "36a6cf0de5de25a9881d37607d5cfbcbbb4f2c520f245259d8aa73fd45361034"
    sha256 cellar: :any, arm64_linux:       "c80e702444f6d7a13e3151ee792370fcc0c0f1908a403c3fda845bc4c7f89b61"
    sha256 cellar: :any, x86_64_linux:      "a4dc4eeb9ad18358fb745221d0af5079be9512c8a8b4b617e1a7c5a7f5d3b1b5"
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
