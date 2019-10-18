class Mfterm < Formula
  desc "Terminal for working with Mifare Classic 1-4k Tags"
  homepage "https://github.com/4ZM/mfterm"
  url "https://github.com/4ZM/mfterm/releases/download/v1.0.7/mfterm-1.0.7.tar.gz"
  sha256 "b6bb74a7ec1f12314dee42973eb5f458055b66b1b41316ae0c5380292b86b248"
  revision 1

  bottle do
    cellar :any
    sha256 "e830c6af97b43df59e1a11b5dda5089f538cbe721ea36c9089719f763f622fce" => :catalina
    sha256 "00a7e4bf781b5e30c3f3802ee2f4a508b31aa415b4dd288dd4d3cde9704f5a9e" => :mojave
    sha256 "6247cf910a93892ad9814fca5c5a3a08a875dbd9b0fcc13328734610f1dc70fa" => :high_sierra
    sha256 "e28bb1b9ffbd2e51afb0d03425cfc3c94f249b28d4f3efd2c32f94220992b2ed" => :sierra
  end

  head do
    url "https://github.com/4ZM/mfterm.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libnfc"
  depends_on "libusb"
  depends_on "openssl@1.1"

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
