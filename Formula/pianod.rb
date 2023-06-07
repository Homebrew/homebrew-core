class Pianod < Formula
  desc "Pandora client with multiple control interfaces"
  homepage "https://deviousfish.com/pianod/"
  url "https://deviousfish.com/Downloads/pianod2/pianod2-392.tar.gz"
  sha256 "d3e24ec34677bb17307e61e79f42ae2b22441228db7a31cf056d452a92447cec"
  license "MIT"

  livecheck do
    url "https://deviousfish.com/Downloads/pianod2/"
    regex(/href=.*?pianod2[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "ea6bd357e1c4adc9485f520ecef09bcea8bf690a59bf7a6c26a1618069e991c9"
    sha256 arm64_monterey: "face4fa3d0b5350001bd9fab327e91b4c93e27b9838739543e51500e7f56f87e"
    sha256 arm64_big_sur:  "be5cd3ad282889c61a990ad65d909a42f65d66df5cd3ee86629e6596e1e3961c"
    sha256 ventura:        "45bf385a68a5a09b10b425606ca1eefb234a7c3a72dc99c1fd4d2c2fe7b221c8"
    sha256 monterey:       "c28a6af22280a294723b9ab645b12be7fea3dd7125a731019ea7e1640ec19a28"
    sha256 big_sur:        "d3f6100a1d1ae88f96c78708ce9b54140a3827819460c8a829c49d08cc5c13bd"
    sha256 catalina:       "f12927568166fb653d124f06a28728e96f0d2e443cb210cfb61f4860ab5935b2"
    sha256 x86_64_linux:   "840ab04307092dacff3212e7822c64a4c03ba77e14ff5f9ad86da1d36b3501ae"
  end

  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libao"
  depends_on "libgcrypt"

  uses_from_macos "libxcrypt"

  on_macos do
    depends_on "ncurses"
  end

  on_linux do
    # pianod uses avfoundation on macOS, ffmpeg on Linux
    depends_on "ffmpeg@4"
    depends_on "gnutls"
    depends_on "libbsd"
  end

  fails_with gcc: "5"

  def install
    ENV["OBJCXXFLAGS"] = "-std=c++14"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system "#{bin}/pianod", "-v"
  end
end
