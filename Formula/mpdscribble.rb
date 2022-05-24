class Mpdscribble < Formula
  desc "Last.fm reporting client for mpd"
  homepage "https://www.musicpd.org/clients/mpdscribble/"
  url "https://www.musicpd.org/download/mpdscribble/0.23/mpdscribble-0.23.tar.xz"
  sha256 "a3387ed9140eb2fca1ccaf9f9d2d9b5a6326a72c9bcd4119429790c534fec668"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?mpdscribble[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "0ad5540e3f2b665958dfa9deaeb1551287d4946be5b143744c0c476cd9e69a71"
    sha256 arm64_big_sur:  "b40d1cf7f4b28d8633fa6f7d3dc9600edab132a0dde8e2d506bea70411051796"
    sha256 monterey:       "a4b7ad909b76117a64e76beb3da3206e45c70d006e581f020520fa5210813a6c"
    sha256 big_sur:        "0abaf443ebb52e23fd027970737ae42d912c66a43b650e5a5ebc5b8abb0483f2"
    sha256 catalina:       "0d75bbf947da0c0fd231994339f0b2c7d23ec9fa5a04532f3c20733064de5394"
    sha256 mojave:         "d2ac4631cea6e610b6ae6b9a007b8c5b2141b0ff55c76b57fbacdbb1a7904a9c"
    sha256 x86_64_linux:   "0ad8f7427437e00cc7e140e52a997d18e8c8bfba665f2f5b1bc308288155b075"
  end

  depends_on "boost" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "libgcrypt"
  depends_on "libmpdclient"

  uses_from_macos "curl"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "--sysconfdir=#{etc}", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  def caveats
    <<~EOS
      The configuration file has been placed in #{etc}/mpdscribble.conf.
    EOS
  end

  plist_options manual: "mpdscribble"

  service do
    run [opt_bin/"mpdscribble", "--no-daemon"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
  end

  test do
    system "#{bin}/mpdscribble", "--version"
  end
end
