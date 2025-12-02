class Libpst < Formula
  desc "Utilities for the PST file format"
  homepage "https://www.five-ten-sg.com/libpst/"
  url "https://www.five-ten-sg.com/libpst/packages/libpst-0.6.76.tar.gz"
  sha256 "3d291beebbdb48d2b934608bc06195b641da63d2a8f5e0d386f2e9d6d05a0b42"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.five-ten-sg.com/libpst/packages/"
    regex(/href=.*?libpst[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "b128a0495dc919ab7254973196f07f1f9c3140e0e6ad420cb31aa65b7c86fd63"
    sha256 cellar: :any,                 arm64_sequoia:  "9f11e376789aaaa81e57b01967f3c9bf1148a6d14885045c311df75e80fad7f9"
    sha256 cellar: :any,                 arm64_sonoma:   "507bcf7846c89dac455e346c2c6bc713df84a70f5888660dd74bbc9b65c38d16"
    sha256 cellar: :any,                 arm64_ventura:  "7c34f9d5b589d9b126e0da006753bc9dcb8eba59aa3f2440bda561d7cea7521e"
    sha256 cellar: :any,                 arm64_monterey: "19a3a8b7fde2b29f509e69232fd8ff7d924c5df201d63cf40512cd7b4831056d"
    sha256 cellar: :any,                 arm64_big_sur:  "d7b9d9f537b1575cbd299b56e2a82f38f661aff617cc8a3a03b44cf8acb1e3c0"
    sha256 cellar: :any,                 sonoma:         "793be875dc2c664635df7073f29d1a09ad348dd90d1a9fca8fe9d715113874f6"
    sha256 cellar: :any,                 ventura:        "9f7ebc7dbf481971d91bdd19fef73063385942694cc7df04aa1ed955defe8d54"
    sha256 cellar: :any,                 monterey:       "9acacad7e57b79446bd4d97551cc026be3cca70f03ac0d28f6622c91b2898c2e"
    sha256 cellar: :any,                 big_sur:        "be3136353a0d0c538070a6c1261b75620abffda9d2cee435daf3debbc5fe2f8e"
    sha256 cellar: :any,                 catalina:       "d6ec30b4b9ca7d8968c5155b98c2a32dca502910c6c95ac860dc50065de89f65"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e37ba9845fdaa861e4d365ecd0be643cee6b01690ddef68d11347d9dcbe93376"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ef7024943254ef22bbf082c8c96ce8d207c30a1b9fe77a8d6f4432d09f924aa"
  end

  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "libgsf"

  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", "--disable-python", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"lspst", "-V"
  end
end
