class Gphoto2 < Formula
  desc "Command-line interface to libgphoto2"
  homepage "http://www.gphoto.org/"
  url "https://downloads.sourceforge.net/project/gphoto/gphoto/2.5.32/gphoto2-2.5.32.tar.bz2"
  sha256 "4e379a0f12f72b49ee5ee2283ffd806b5d12d099939d75197a3f4bbc7f27a1a1"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/gphoto2[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "4964d268b7a6e5fe54ace7bf390f1986757b9c1d1f3444e324e8f6f6e026f919"
    sha256 arm64_sequoia: "189e99f72f8ec50a706151bf4b3ded54ace4ca3bc0fe2fa11898d68f2bc87e9d"
    sha256 arm64_sonoma:  "11188417b4d967bca29dba9e5e14801e44b110b4c55659407825f550e6dcedb6"
    sha256 arm64_ventura: "01525ca78cb62c595c565025b28bcd4fd07792ff01c91292a08c35d918b4100e"
    sha256 sonoma:        "69b5f9a17b27bf5ec53c0dcd61c2c8aea8bffe3017afb6e510f634d2c12e60d3"
    sha256 ventura:       "aff2e028f6ab3cc76f521ae161f729541eaf68e44d987ce1948967f3b792a4aa"
    sha256 arm64_linux:   "c74def980e8a6375630735e1069673b09ee7c2366455c6a1b6b25abe7be1a168"
    sha256 x86_64_linux:  "6e7c517d9fca1d5befe7bbfa1012f495da43e64df141249bdae00884ce5a5475"
  end

  depends_on "pkgconf" => :build

  depends_on "jpeg-turbo"
  depends_on "libexif"
  depends_on "libgphoto2"
  depends_on "popt"
  depends_on "readline"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gphoto2 -v")
  end
end
