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
    sha256 cellar: :any,                 arm64_ventura:  "7f8f3b0863a492822fb17eea6c2b8200902daac2b675d1f8ee8ec630460297f0"
    sha256 cellar: :any,                 arm64_monterey: "ed0cc88b82dee2ed2e819726858e3fa32304ede4b9920f610e4e58060e245bc6"
    sha256 cellar: :any,                 arm64_big_sur:  "f08eb7c2f858f394a688a70992d3d17f3b5789449522fae3c7c0c94e3278f3c8"
    sha256 cellar: :any,                 ventura:        "f2e08f998c765c0d2703d3bf0d77f332923da73c6cf5e74f0d0ed9191ae639c6"
    sha256 cellar: :any,                 monterey:       "7fb5903fcebb64f0d45b583f7e87a75c72ced74c61d532e6e251f680be245d7f"
    sha256 cellar: :any,                 big_sur:        "25e319ceb759a5e144df9bcf57a91189f9a11c4affbceebd555e3392329306a8"
    sha256 cellar: :any,                 catalina:       "aa4615ea703a4c352e037fd0d0dc5c3539c41f6ed64c475fbac00157c56176aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "656fad8d62446aa6aa9200db2a4d05b8b28b9971d4c32923dd09854315314e1c"
  end

  depends_on "pkg-config" => :build
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "speex"
  depends_on "theora"

  on_linux do
    depends_on "openssl@1.1"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end
end
