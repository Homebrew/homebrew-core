class Pianod < Formula
  desc "Pandora client with multiple control interfaces"
  homepage "https://deviousfish.com/pianod/"
  url "https://deviousfish.com/Downloads/pianod2/pianod2-394.tar.gz"
  sha256 "0a88dae7f9df137eae718116b548aabe7b3a47e7cec44d0a2f379994d9a16b8b"
  license "MIT"

  livecheck do
    url "https://deviousfish.com/Downloads/pianod2/"
    regex(/href=.*?pianod2[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "358996ad3ec3b99a44b73701a19c6006079df8c65413c17a0f45cf7a61046358"
    sha256 arm64_monterey: "3f446e0b58083732f1909ae488489ecc1ff1acb37f04cbfb14d9db54bee52a15"
    sha256 arm64_big_sur:  "8b044fafe4e653c752c6e28eb81c245213781bc38712c84c63977c797d4942cb"
    sha256 ventura:        "48f82496158415fd4a26c8ba0f87fbde513a2ce74cc128bc7cba9635365e27f1"
    sha256 monterey:       "8740c27cdf2f7196cd357988e97ad4023021e9af445efea166d95a38b6e94c42"
    sha256 big_sur:        "4364ef38e1903d801afc86eace82eea4def9a8fc8e1e90129073b87950b30fcd"
    sha256 x86_64_linux:   "61a82bad5ccc213100234050422784fb62385a4eeb36a5870c47f6785159e50f"
  end

  depends_on "pkg-config" => :build
  depends_on "gstreamer"
  depends_on "json-c"
  depends_on "libao"
  depends_on "libgcrypt"

  uses_from_macos "curl"
  uses_from_macos "libxcrypt"

  on_macos do
    depends_on "ncurses"
  end

  on_linux do
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
