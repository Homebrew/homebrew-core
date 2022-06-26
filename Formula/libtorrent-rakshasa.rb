class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://github.com/rakshasa/libtorrent/archive/v0.13.8.tar.gz"
  sha256 "0f6c2e7ffd3a1723ab47fdac785ec40f85c0a5b5a42c1d002272205b988be722"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2afd6ff42e6e7a61500522b2fbfa7662afc02575406217efd6416c3ef11fef8a"
    sha256 cellar: :any,                 arm64_big_sur:  "5ddf92897806c7897987f4d86803db65f4fbb1ae0dadf91422971b4d58bda2f4"
    sha256 cellar: :any,                 monterey:       "268a4a4e502d7670ef585940c79fe6cb4b8d406910a8411212478b91fbe5ef59"
    sha256 cellar: :any,                 big_sur:        "1d2275d886729ab6076582c7b399df2e0748f8a50b31f88a3a2f871ca097985d"
    sha256 cellar: :any,                 catalina:       "207e33009028a8721a89c91139fe78fea1cd9fb8a05862286264dfc53548886a"
    sha256 cellar: :any,                 mojave:         "94afd9fcef673d4e3945c13085df931e12c1bf2422bf6a2ad2c6848634c2fa65"
    sha256 cellar: :any,                 high_sierra:    "135df02ce3bb98b05d9f849b8014087e8acaefcc24b1547ff9b1740bbd74492a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "521b80ae43269a92261c7fcca34ab42f11031550055815a64baeecd837a2d4d5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  conflicts_with "libtorrent-rasterbar",
    because: "they both use the same libname"

  def install
    args = ["--prefix=#{prefix}", "--disable-debug",
            "--disable-dependency-tracking"]

    system "sh", "autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <string>
      #include <torrent/torrent.h>
      int main(int argc, char* argv[])
      {
        return strcmp(torrent::version(), argv[1]);
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-L#{lib}", "-ltorrent"
    system "./test", version.to_s
  end
end
