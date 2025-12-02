class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.16.4.tar.gz"
  sha256 "8575172389d668e0da76320850f186ab7a482fffe314444866a3de593ad85aaa"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1331b535bafede26577e1da404ba2af8124f9f25c6c3cf21b3eb710a40dd3697"
    sha256 cellar: :any,                 arm64_sequoia: "6579466580750b1f68dc6af5b0e08514aa4cd6ef846b204e05d86ae4cc7906a6"
    sha256 cellar: :any,                 arm64_sonoma:  "d9672f1a8e4cb75306af072b0007b9655187260fd9a05ffecc30f4b945af0eea"
    sha256 cellar: :any,                 sonoma:        "650689bebe1e0a8bb9d4cc736f8e544bd21a116a25db30ac35ad7a5a0f8d7def"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2616dcf8a1bf6e178ebce15aa168c8b3974a8e5c6f297a0ca94cfbe55cbc45c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0f106e8bc1c4eaa5b7b5ac9a7df48fa6af395c31525173e21c7f310902f6a36"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

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
