class Mfterm < Formula
  desc "Terminal for working with Mifare Classic 1-4k Tags"
  homepage "https://github.com/4ZM/mfterm"
  url "https://github.com/4ZM/mfterm/releases/download/v1.0.7/mfterm-1.0.7.tar.gz"
  sha256 "b6bb74a7ec1f12314dee42973eb5f458055b66b1b41316ae0c5380292b86b248"
  license "GPL-3.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7c66e15be8f86726fe114bb9c0be3684386f62819af22e7892876634b22b4d8d"
    sha256 cellar: :any,                 arm64_big_sur:  "e7dffabd037eaff9a07ef2adb7c5731bd6270f04e5f3590280293fc25d478ddb"
    sha256 cellar: :any,                 monterey:       "375cd87233c4faea0360d7b840ff7ebd7769a455429f70c8b60305bef1b32299"
    sha256 cellar: :any,                 big_sur:        "18cc9c42960d0accd760293232f236ad1d35e0fc1e7e8f44061b72db2c2acf64"
    sha256 cellar: :any,                 catalina:       "1c9230a17ab7102f4b171e37a972ade6c7e2d5708102a17ea5494be0b1d1a42e"
    sha256 cellar: :any,                 mojave:         "2b4c61222b70b25c523c6083efd85ff53f1187a6afd7d88115f12cb788fa6b13"
    sha256 cellar: :any,                 high_sierra:    "c481733fcc5f8057aac9fa38d5445a88e6faf54a016533bcc72eba2335d9754b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39fc6b17d7d53406b021389245015114195ec47f11787faafa1b60d92100e8da"
  end

  head do
    url "https://github.com/4ZM/mfterm.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libnfc"
  depends_on "libusb"
  depends_on "openssl@1.1"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    ENV.prepend "CPPFLAGS", "-I#{Formula["openssl@1.1"].opt_include}"
    ENV.prepend "LDFLAGS", "-L#{Formula["openssl@1.1"].opt_lib}"

    if build.head?
      chmod 0755, "./autogen.sh"
      system "./autogen.sh"
    end
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "#{bin}/mfterm", "--version"
  end
end
