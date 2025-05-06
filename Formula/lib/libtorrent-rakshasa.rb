class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "dd0e011dfe0c37b8a41cfc7a778cc92e52352f1091347ab98e63aa8a5c532dad"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "aae08b9065da39bdd064e40093c036910b82d0027154acf6d962a65da4522471"
    sha256 cellar: :any,                 arm64_sonoma:  "0f7313ad11b0cdc8b393822998d72092190c4c00a4bff325a9a0a26a64977dc0"
    sha256 cellar: :any,                 arm64_ventura: "88fb4e3bc74fdcae648065d500e828af08edf7e989184f7aefbcb81fa2d11690"
    sha256 cellar: :any,                 sonoma:        "f7f10cac907ca356a8675e959b30b7c395cf283a60af4452e6483f0df5b47e4a"
    sha256 cellar: :any,                 ventura:       "f39089fd6cebb5801e690bca5478cbf16fdc65869561d63deb2fa3977878ca51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddafcff4313b0e209d382cd8fd823c549a2e25a3b0c28fc4e9dfae879d51d733"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb092fecdecfca889ccf075a8a139b8827798272898d084b6ac58055e0789d19"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  conflicts_with "libtorrent-rasterbar", because: "they both use the same libname"

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
