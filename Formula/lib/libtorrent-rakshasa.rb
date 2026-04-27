class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.16.10.tar.gz"
  sha256 "d3cb19453f7e21580fc87b997862deb46d7f11eff5fb6f5f9967b8b56f031101"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "02359b4fef190638f9288b93e92cf475ae02c6c651579f4ed5470c0912bf894b"
    sha256 cellar: :any,                 arm64_sequoia: "a53104ab26ad26cdeb65226a7b5fb4aab1296270d4577ed786c973dd5abe9711"
    sha256 cellar: :any,                 arm64_sonoma:  "4b1b6782ecfef9e6fdae3f920bd46d58bf742584259fc9b06b8b8011b725704b"
    sha256 cellar: :any,                 sonoma:        "2e153e53966d839d9d710de3150f0fbc746f0f892100d94ac0a7d0fd7393d6e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c606a71e54bfb4c2d2acf9697d5222e6ab527564999094ec073f1ad8e2f178bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93caed7d941d85302aed11e6c03366b12bf2cc5f362958ef01976b05d59d556a"
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
