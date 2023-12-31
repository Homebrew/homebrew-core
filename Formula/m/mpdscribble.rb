class Mpdscribble < Formula
  desc "Last.fm reporting client for mpd"
  homepage "https://www.musicpd.org/clients/mpdscribble/"
  url "https://www.musicpd.org/download/mpdscribble/0.25/mpdscribble-0.25.tar.xz"
  sha256 "20f89d945bf517c4d68bf77a77a359fdb13842ab1295e8d21eda79be2b5b35ce"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?mpdscribble[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "bb677d73c33aa3c1a22f8c85b5c0e829ba230ce3faf3ea433c6662ee33496c0e"
    sha256 arm64_ventura:  "44fe41a3ba49b3b70de39f3b36067ce5011a2d12f92b27848234db79bc561242"
    sha256 arm64_monterey: "cd70d1bf103b1abddfb3396a77f5a8ff373b42103f1d56b679c560e63d577e69"
    sha256 sonoma:         "a56d2f601abc41777b2fead2ac177532a4520fc923d876c1505b29cee1c24e9d"
    sha256 ventura:        "e87c590b8e83b9f6085531deb948b7bca8a55de844f6fa3608036aa82050b2a6"
    sha256 monterey:       "6737329de585fa6af1a59f076f418b4f552944be5eff1126c462e1cecbd35a96"
    sha256 x86_64_linux:   "4e5852c3dcb301ca9378826b19a679be1b0592d1b99dc64bed775ef092f4eecc"
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

  service do
    run [opt_bin/"mpdscribble", "--no-daemon"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
  end

  test do
    system "#{bin}/mpdscribble", "--version"
  end
end
