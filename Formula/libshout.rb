class Libshout < Formula
  desc "Data and connectivity library for the icecast server"
  homepage "https://icecast.org/"
  url "https://downloads.xiph.org/releases/libshout/libshout-2.4.5.tar.gz", using: :homebrew_curl
  mirror "https://ftp.osuosl.org/pub/xiph/releases/libshout/libshout-2.4.5.tar.gz"
  sha256 "d9e568668a673994ebe3f1eb5f2bee06e3236a5db92b8d0c487e1c0f886a6890"
  license "LGPL-2.0-or-later"
  revision 2

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

  depends_on "pkg-config" => :build
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "speex"
  depends_on "theora"

  on_linux do
    depends_on "openssl@1.1"
  end

  # libshout's libtool.m4 doesn't properly support macOS >= 11.x (see
  # libtool.rb formula). This causes the library to be linked with a flat
  # namespace which might cause issues when dynamically loading the library with
  # dlopen under some modes, see:
  #
  #  https://lists.gnupg.org/pipermail/gcrypt-devel/2021-September/005176.html
  #
  # We patch `configure` directly so we don't need additional build dependencies
  # (e.g. autoconf, automake, libtool)
  #
  # Patch has been submitted upstream:
  # https://gitlab.xiph.org/xiph/icecast-libshout/-/issues/2332
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end
end
