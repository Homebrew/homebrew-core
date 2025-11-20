class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "68391b28a55cb039eb385a20cc9333ade0646bea4d13c05e2b40c080d33c7505"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "725f81dba44edbe035a6b4f2a1cf7914fba50bcfc5dc5859705185bd2cccc6fd"
    sha256 cellar: :any,                 arm64_sequoia: "e8f5099c09b77536103376b306d20e9595c8c331fd2ac6c0a6541fbaeab4b7cb"
    sha256 cellar: :any,                 arm64_sonoma:  "84443108841927551062ca7844210dec04feba32177152595eb95ace0ba133fa"
    sha256 cellar: :any,                 sonoma:        "fca0654eb0eeda71f2a1898ec1ba6f6fef195434a975a80d8ed1b4dc2f52a7b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3196b28a608db5dcd3e3289fdc2cfb1601c14ed608bfad425843e71bf7de1b6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10f72d3df10c7d7dc807a469a906115f9968cd477d62f933ae8a255f354b8a01"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  conflicts_with "libtorrent-rasterbar", because: "both use the same libname"

  # Backport fix for arm64 page size
  patch do
    url "https://github.com/rakshasa/libtorrent/commit/b16ecf23fde95857a462dd4cb3545b4ea9408aca.patch?full_index=1"
    sha256 "d40e3f46691e6ac0f6c238823a65d59cad102c905c3714505d3f710b55821dca"
  end

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
