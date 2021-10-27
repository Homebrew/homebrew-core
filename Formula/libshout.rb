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
    sha256 cellar: :any,                 arm64_monterey: "29356ba3e0a8682ccbc1a4b6016497e3576c31e9df99901b6ca022a5a548e2ce"
    sha256 cellar: :any,                 arm64_big_sur:  "306fcd9e630fd90b82c5d58d1f7b07692f2cac16c05556ff3dfeec64c09fdee0"
    sha256 cellar: :any,                 monterey:       "b9b4655de3a51803433b4b4675d82b4371af868b1b440cd7f0a7c61d234979c1"
    sha256 cellar: :any,                 big_sur:        "7ae2c10ce823cb25566f75911560dbabd691bb818ee38a77c7eb2cba831c63bb"
    sha256 cellar: :any,                 catalina:       "0cb9a2d80370e8da49143cc896f209ff44f06d903e8050a867851f2dc1c3f3e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62ae4123383c7e4a09efb4360c06ce8e06ac48f48a509c4d6d340fedd9085aff"
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
