class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.16.8.tar.gz"
  sha256 "8dd691bde908a6d290f36282e0af8e8daa4d3fccc811d21a78bdb3684354a56e"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ec1729f0950a03970d0db443dd791f62550f057334ad711f7122ebb1758589b4"
    sha256 cellar: :any,                 arm64_sequoia: "317b575b34f1ab5a3cbf784a9496e6eb8d02212b898a253f3c0e24419973efdd"
    sha256 cellar: :any,                 arm64_sonoma:  "2daf5746574afd0bbda4925be5ad5f191ed8c7448f84f3c40d1a4d9aefffb178"
    sha256 cellar: :any,                 sonoma:        "154b6261a61fc316a5b6930d085d9ac106894e2bb828f75b6b2b50b11fe08ee8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cef2e1f29cc110da2b7790937b93ff236b83d63723b100a117823c49cf9a2dcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b3d6754329a0415fc23d0fb643dd28fd13447c96711c3614b9765e393c4e0ab"
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
