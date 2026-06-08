class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.16.13.tar.gz"
  sha256 "17a3bbf8a75b18347e460c479f51ee1f1e4927bcdd444052940df6f0b31a530c"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d59a11b34754c983e34846ed1f010e8e448e7e63f1afa1475fa51aea2cc20c97"
    sha256 cellar: :any, arm64_sequoia: "054442abcfdb99c8d08d6952f3a95c2090a5f5829afa6d5e5b5f0a235b96eed6"
    sha256 cellar: :any, arm64_sonoma:  "2a969a5bd5ec7baf57b4b1aef7887607e62f9e14990b60d95358944f9159a95a"
    sha256 cellar: :any, sonoma:        "8623584b8d734b1cd4e18f6950122f5f829b5cac8b4ae9354b8a20182d72b8cf"
    sha256 cellar: :any, arm64_linux:   "c2b60db0ae6a824c0698518b885d4416fa8a318fc5b550015f0e5b5bbd57d601"
    sha256 cellar: :any, x86_64_linux:  "18e6a96d5f00853ac79c7733c18c3e83835ec07d58b668a51b69b96614b2a120"
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
