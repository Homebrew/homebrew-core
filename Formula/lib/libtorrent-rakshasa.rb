class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.16.11.tar.gz"
  sha256 "b1ccbc0f2241d840957d6e82cf1ea35fd537220d3f5478fef23994bd292bf184"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0c4138afcf161df70bbe73e27eb85544ef7398143f44b4543dee9bb2f3f011d5"
    sha256 cellar: :any,                 arm64_sequoia: "c5b294fac3ed526a83b55b4a9d932065dd652a3b1b4f740710eeef2fea065c9f"
    sha256 cellar: :any,                 arm64_sonoma:  "25db9a0301001ede2bdda8c0c0f4dcf1906be7099cdfdea171f5353ce63fd045"
    sha256 cellar: :any,                 sonoma:        "65f7de5c6a71f360a481795d264acbcc5ae4486e46acde5e248465b9ed4f768e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5c890408c17634d6cee9dc25953eae2ee609c21be4aed3a70a8aac71ef44a07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76774fdcf1c39b5ec79253dc5054dade569ffe00d6eda9478274f56f9319b448"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "libtorrent-rasterbar", because: "both use the same libname"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>#{"  "}
      #include <torrent/torrent.h>
      int main(void)
      {
        std::cout << torrent::version() << std::endl;
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-L#{lib}", "-ltorrent"
    assert_match version.to_s, shell_output("./test").strip
  end
end
