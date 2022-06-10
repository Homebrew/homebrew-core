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
    sha256 arm64_monterey: "dd206cf35e1a07f0f68400cf16ac18086c3afa7d7e8acfc40e2e7a963031b6c3"
    sha256 arm64_big_sur:  "3174a7fa46e88cab7f8b059a9b4644085a440b783041e7a80b764c5131113c92"
    sha256 monterey:       "83dcf7863e64c0eea4b753b405ed444798b23be7c4ab0fdd4899f3139781520c"
    sha256 big_sur:        "8458fbc6e9701e6db6242654fffe197e08cb1053b3adab5d1952fd9ab507905d"
    sha256 catalina:       "1e2b9ea9d68f670875cd8359ee56d21a7f670c3286bcfd4dcef70f58bb6a0923"
    sha256 x86_64_linux:   "a5e3c64179f2a2508bb8176c3522f463b7e7753376789824f9526fdf857233fb"
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
