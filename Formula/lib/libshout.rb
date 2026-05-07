class Libshout < Formula
  desc "Data and connectivity library for the Icecast server"
  homepage "https://icecast.org/"
  url "https://ftp.osuosl.org/pub/xiph/releases/libshout/libshout-2.4.6.tar.gz"
  mirror "https://mirror.csclub.uwaterloo.ca/xiph/releases/libshout/libshout-2.4.6.tar.gz"
  sha256 "39cbd4f0efdfddc9755d88217e47f8f2d7108fa767f9d58a2ba26a16d8f7c910"
  license "LGPL-2.0-or-later"
  revision 3
  compatibility_version 1

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/libshout/?C=M&O=D"
    regex(%r{href=(?:["']?|.*?/)libshout[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b394e0a6fd09c7ba4b53579a82a529c5ce5c1ed41cdb49981efe603675d6f5fa"
    sha256 cellar: :any,                 arm64_sequoia: "1d2ace0c95fcbf33c4a63af683467c33fd06c7ec664ab7089eba60f85d66cc0a"
    sha256 cellar: :any,                 arm64_sonoma:  "32c215d0035f50f20904bc426ce29c6bf12b086366f3a5c8b6c13cce72415783"
    sha256 cellar: :any,                 sonoma:        "b94034f786b46eb57a033eebfbab7343e87fb030d127d5dbbe390fc55e8627be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f53d2f3520652af063c41d488b1738af1a23fc2bb64be3d0604dd8ec2324cc13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "663a5903d6aaa29f2ca8010eef9c437e2ba8b1fce8120d4a107b8c53b99e0f87"
  end

  depends_on "pkgconf" => :build
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "openssl@4"
  depends_on "speex"
  depends_on "theora"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", *std_configure_args
    system "make", "install"
  end
end
