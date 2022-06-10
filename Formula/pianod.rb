class Pianod < Formula
  desc "Pandora client with multiple control interfaces"
  homepage "https://deviousfish.com/pianod/"
  url "https://deviousfish.com/Downloads/pianod2/pianod2-388.tar.gz"
  sha256 "a677a86f0cbc9ada0cf320873b3f52b466d401a25a3492ead459500f49cdcd99"
  license "MIT"
  revision 2

  livecheck do
    url "https://deviousfish.com/Downloads/pianod2/"
    regex(/href=.*?pianod2[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "0d073dfee987e7ca3c7a31798897038e6f8574d139ebb5dd3f961898b42d1717"
    sha256 arm64_big_sur:  "5f866675ea22630eff9285178798f927388f140ab7d90d896aded6f7d5ec36d0"
    sha256 monterey:       "df931845b48acafde0e4364c5561a59479fa0a3ea8ccbc8fccefa10b8177b749"
    sha256 big_sur:        "eb1e455a6ba78cfdb98f1e0d5be39b9922b9b32f7aa598af0b780b68cac3c587"
    sha256 catalina:       "f8a6727b19dde7b3688a80c773c2cfba5b9aec584e98a81023732e07e7069eeb"
    sha256 x86_64_linux:   "436b91eceec551f9c5b6b7b202aebe34715f45eba87b1c5753357360c9c2be98"
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
    depends_on "gcc"
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
