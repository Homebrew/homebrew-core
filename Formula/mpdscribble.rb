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
    sha256 arm64_big_sur: "e0a631278cb1d14dc4ad63897a68eebd23e5882c4fd9247099d5af1e3e545b4e"
    sha256 big_sur:       "b79e64ee861ea63530317a540dc37222f202a63b59810660b0f94538c16e7334"
    sha256 catalina:      "d8e226d580e44da3f93849bfdd6065a356e9d0e2cf086c31cc4be273e3152980"
    sha256 mojave:        "f6c7e1d2b4f6112ae2b0548e0571580f4f671789e81eb799efc92ac236cd2d0b"
    sha256 high_sierra:   "68c6dcdc89b8cbdd8b8c5fea0822cfdb883874b390cb5a9a69192880a3b03838"
    sha256 sierra:        "bfc893a2fe7e712bfc17f83aeb7e5f9cf46d260f3d5756cd499a6a6100c1feec"
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
