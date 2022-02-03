class Pianod < Formula
  desc "Pandora client with multiple control interfaces"
  homepage "https://deviousfish.com/pianod/"
  url "https://deviousfish.com/Downloads/pianod2/pianod2-388.tar.gz"
  sha256 "a677a86f0cbc9ada0cf320873b3f52b466d401a25a3492ead459500f49cdcd99"
  license "MIT"
  revision 1

  livecheck do
    url "https://deviousfish.com/Downloads/pianod2/"
    regex(/href=.*?pianod2[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "a6a0d3d09f37467874c46890a433ed9aec355546a37134e20ff06c9f7bc12fe4"
    sha256 arm64_big_sur:  "89128e2bd19a66a0e1b5de123934476cd6903bc87113d88445d40171382fdf56"
    sha256 monterey:       "b2f7d2be7b2f6b69be17556a5f6eaed586462e755cfbf1975cb5e3556b185cf7"
    sha256 big_sur:        "5a8f72e099726bf3b32e651fe095c1a683c12410a4778c46ea464e78176365d9"
    sha256 catalina:       "7e694341f6ccf08808c9f156253d407449334d60121bbd6352093e088546b9dc"
    sha256 x86_64_linux:   "cc7b9f0d948a2f1a0c1673bce83a543844bfcd58a6fd9b83ed7738ebb0918ab9"
  end

  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libao"
  depends_on "libgcrypt"

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
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/pianod", "-v"
  end
end
