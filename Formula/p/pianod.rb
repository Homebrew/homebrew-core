class Pianod < Formula
  desc "Pandora client with multiple control interfaces"
  homepage "https://deviousfish.com/pianod/"
  url "https://deviousfish.com/Downloads/pianod2/pianod2-405.tar.gz"
  sha256 "f77c8196123ddb0bbb33a40f9fc29862f1df0997e19e19ecd8cbce05b336bf61"
  license "MIT"

  livecheck do
    url "https://deviousfish.com/Downloads/pianod2/"
    regex(/href=.*?pianod2[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "77c82ba532faeb21102c31fdfce889654bc128c39ee918e53065d80fa68c2360"
    sha256 arm64_sonoma:   "54a50ee4b3ccdce33beada794a379f5709e5523f6bdb9fe6317bf8f199e035f2"
    sha256 arm64_ventura:  "61d74b10d6f05abb5d67d2227458a1203cc9ecc812add4210ad4567aa137b8a7"
    sha256 arm64_monterey: "0eeff011708a6f207220675fea7182ecc3c3e8da436f6f0c206400ece8136907"
    sha256 sonoma:         "5f7e7897d21d5b5093853cce2b0cae1ee3680e3f95c6bf3316b7564f40cb038e"
    sha256 ventura:        "c70427ba76dc3a417fa8e8ff400e01bf740e40d34a12a39934fb953e8a88a1d2"
    sha256 monterey:       "1fe0b168bd7cdf3651d790bbb1693b3d45c00b14489f3e782978fd8399a0e5da"
    sha256 x86_64_linux:   "29141d3fcb442321213fa4fbdf575003a67e012036975c8fbfff1299096abc44"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gstreamer"
  depends_on "json-c"
  depends_on "libao"
  depends_on "libgcrypt"
  depends_on "taglib"

  uses_from_macos "curl"
  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "gnutls"
    depends_on "ncurses"
  end

  on_linux do
    depends_on "gnutls"
    depends_on "libbsd"
  end

  fails_with gcc: "5"

  def install
    ENV["OBJCXXFLAGS"] = "-std=c++14"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"pianod", "-v"
  end
end
