class Ncmpc < Formula
  desc "Curses Music Player Daemon (MPD) client"
  homepage "https://www.musicpd.org/clients/ncmpc/"
  url "https://www.musicpd.org/download/ncmpc/0/ncmpc-0.47.tar.xz"
  sha256 "61da23b1bc6c7a593fdc28611932cd7a30fcf6803830e01764c29b8abed2249c"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.musicpd.org/download/ncmpc/0/"
    regex(/href=.*?ncmpc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  # Linux bottle removed for GCC 12 migration
  bottle do
    sha256 cellar: :any, arm64_monterey: "9c5a751cf1cdf763576b2a5af746ae5f0042cbc2eceb1fb2057ce8f0d4a7e3fc"
    sha256 cellar: :any, arm64_big_sur:  "59fb26a2c225c8f652a4bd075e3536677f435a804d5acf774f893759cf1e5ce5"
    sha256 cellar: :any, monterey:       "3c0eeb6d9f4de139daf1ed63d8f8e9fbe8f5ca41b47d93aae5b2d14dedff4888"
    sha256 cellar: :any, big_sur:        "630160a894df86a9f369740acde9e92880c36b7262fab5a75857123d67ea8aa8"
    sha256 cellar: :any, catalina:       "07e7f1e1a017591372496368045eda2e871a1d5d2a9bfcf57f5408b3608335c5"
  end

  depends_on "boost" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libmpdclient"
  depends_on "pcre2"

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dcolors=false",
                                       "-Dnls=disabled",
                                       "-Dregex=enabled",
                                       ".."
      system "ninja", "install"
    end
  end

  test do
    system bin/"ncmpc", "--help"
  end
end
