class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.16.25.tar.gz"
  sha256 "c0390ef3454e9456aadb21f704eac6ef659bccc2b3ceb8215f59f1ef30735a14"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ae523161c41b5937d18467abf65b10131023ee851c8abcabb0b4d19b71784d33"
    sha256 cellar: :any, arm64_tahoe:       "8a5e1896a1e3442816ea6dee8db8285109d4d4f44e0d617c6bdae58549b8c4f4"
    sha256 cellar: :any, arm64_sequoia:     "e987d2977803a35a242ef6ecfa0183201a334454772430ebf57b92847dbf3deb"
    sha256 cellar: :any, arm64_linux:       "234a0f4dff91636fb9d27551e8e1bf8cbd0b93abab13b07fd809f4cb5300b0df"
    sha256 cellar: :any, x86_64_linux:      "bef188ae45e5d5a1b4c11355a67d41b46e2935d261319bbe2479903b1f91be49"
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
