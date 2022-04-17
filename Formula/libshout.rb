class Libshout < Formula
  desc "Data and connectivity library for the icecast server"
  homepage "https://icecast.org/"
  url "https://downloads.xiph.org/releases/libshout/libshout-2.4.6.tar.gz", using: :homebrew_curl
  mirror "https://ftp.osuosl.org/pub/xiph/releases/libshout/libshout-2.4.6.tar.gz"
  sha256 "39cbd4f0efdfddc9755d88217e47f8f2d7108fa767f9d58a2ba26a16d8f7c910"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/libshout/?C=M&O=D"
    regex(/href=.*?libshout[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b92fe6bfd21cffc234722c4bad720678ad0e23c2892ee3dd8b89dd0ffed684bd"
    sha256 cellar: :any,                 arm64_big_sur:  "d5c5dbd03147d012b21790c4ca964b4a55be8af565dd361c7677581966f435c9"
    sha256 cellar: :any,                 monterey:       "d996af9b8f49227e6fe3a5dd7817c1d7a98220d51579d7ab4eb30d94a8fb0da7"
    sha256 cellar: :any,                 big_sur:        "f7b310e1263bc374eff88292691e3264dbff740b0036b3cbf76b3a86255d035b"
    sha256 cellar: :any,                 catalina:       "63071140ce558d6bb252a677b4d77913c5151fae52150648b90d5903fc5249cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd94f36cce287abf74b00f18dd17f995afb81accc1199daf5fe07cfa9693c9a8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "speex"
  depends_on "theora"

  on_linux do
    depends_on "openssl@1.1"
  end

  def install
    system "autoreconf", "-fiv"
    system "./configure", *std_configure_args
    system "make", "install"
  end
end
