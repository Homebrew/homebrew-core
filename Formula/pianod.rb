class Pianod < Formula
  desc "Pandora client with multiple control interfaces"
  homepage "https://deviousfish.com/pianod/"
  url "https://deviousfish.com/Downloads/pianod2/pianod2-376.tar.gz"
  sha256 "ac00655c1e3c7507ff89f283d8c339510f50e9ddd5a44cb1df7ebcb2e147e6d1"
  license "MIT"

  livecheck do
    url "https://deviousfish.com/Downloads/pianod2/"
    regex(/href=.*?pianod2[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "bf0828b5121524385982b319bc232292a5eb2439562955b1736037444468298a"
    sha256 arm64_big_sur:  "56ab9d2c636cf273f208ffe8fb75d9b125361e445fa755920f9f582ec32e1afa"
    sha256 monterey:       "9435a267507da828e96d612c833fae22b0bdae8c90db55bf2f5bcf9ce12864e7"
    sha256 big_sur:        "3aaed35adde0c5e286691e0cec46cf841d21e8990449fe8ce44a1b19206fac81"
    sha256 catalina:       "1eb5a5505c87c7e3507c56770567bfedfd778322989416d028ba964c5177ef06"
    sha256 mojave:         "416d3972a515b932768d6e6ee1412c266e640f9b5bc734f00974a1b35bd40b80"
    sha256 x86_64_linux:   "639af5a5c17e693c8ae599f20e76f5a58fafb804df91cccf69a7dfc2fd831d3c"
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
    depends_on "ffmpeg"
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
