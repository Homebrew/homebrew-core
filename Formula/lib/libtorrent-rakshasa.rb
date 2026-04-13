class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.16.9.tar.gz"
  sha256 "530e6cc472feeb492113ca1051ac546c093e17f250394f58eb64d65859bff84e"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "23d003866ceb54e471df38f41dd0cb632a1ee3fa7f4d44686e1f04d2d2d44be0"
    sha256 cellar: :any,                 arm64_sequoia: "5074aab16b5429f86adf791304b412c15aa05be97a04bce6298d060231201e2b"
    sha256 cellar: :any,                 arm64_sonoma:  "35bf1d43e62e7463e38aa110f3cbac11f2a3e13fc3047a5c70a33562128e6bae"
    sha256 cellar: :any,                 sonoma:        "9fc18de97fd9b2edd190534f36fb9d520483b86861046a99180a2936ca4096bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c692677aa7736d875f8f825976645a81fecf474977a6cdfd4ecc43d62ac2f438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a49a2a9132af8cde7c162d99500e99932fc9af99b71c149866095542ffb4ef77"
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
