class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.16.20.tar.gz"
  sha256 "f824c9a88dc7c0890476b28248134339163d10159af03127d9e9bbb2097be641"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e1360cc7601fc856d487362af63f89a299ab8290d07426d9943fd7d80ad9e2c0"
    sha256 cellar: :any, arm64_sequoia: "64da7428c531c25313a9af504f5d1e72819cc18eb7da66837b7c48cde7cce954"
    sha256 cellar: :any, arm64_sonoma:  "e04b31a606850d09199016f9f1f32781bc1ab324e6950f5359a755a612dcbdb0"
    sha256 cellar: :any, sonoma:        "84aedd361ff96a386feb9462ece5b2ad77ad3ac7ff945d7ea5638d362912acc6"
    sha256 cellar: :any, arm64_linux:   "0f8c367fe3906ef16193ebbebb14bc4d9082aedce2ae2f4c4ca786b68a495959"
    sha256 cellar: :any, x86_64_linux:  "c922e5b58d2e9ca8e890ef943949fa60c04bca01205da8e00deb788e03a83e55"
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
