class Mjpegtools < Formula
  desc "Record and playback videos and perform simple edits"
  homepage "https://mjpeg.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mjpeg/mjpegtools/2.2.1/mjpegtools-2.2.1.tar.gz"
  sha256 "b180536d7d9960b05e0023a197b00dcb100929a49aab71d19d55f4a1b210f49a"
  license "GPL-2.0-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "3b9ddb01e9c28192d76d02795aeec7c686663dca28d67b7997901c12ba0a3368"
    sha256 cellar: :any,                 arm64_sequoia:  "ceffd1cacfbd70df4bc8763a63379aef688299d0d454243034964ae4d990fc87"
    sha256 cellar: :any,                 arm64_sonoma:   "819ed433976e0822f4357ab0b24f2de38f32500e169add9671ebd0fda5d1a818"
    sha256 cellar: :any,                 arm64_ventura:  "6617edf8918a64e1850a6b94627617a460dc85234bf56c2c4f0af9bd77608d3f"
    sha256 cellar: :any,                 arm64_monterey: "c7d05e5fc6d485aa298f4aa7ce6cdfb0c28f2a7792650bba2e3fda8adc030f85"
    sha256 cellar: :any,                 arm64_big_sur:  "35bd5112b5352ad73c9636e205134628682d93f2502d33951945f676464f1e72"
    sha256 cellar: :any,                 sonoma:         "1c8e6fee330874d11f0da2845385ce577e8d1727458960d7d43074e0dc12a66c"
    sha256 cellar: :any,                 ventura:        "1e9e03514b9817e89ed635a9657bb226a3582b52765511e8a8fd36f5a7208ced"
    sha256 cellar: :any,                 monterey:       "9afd34745954ea736c8e894c42b4552aa414df0d44942a09d7c47a6113c3ed2b"
    sha256 cellar: :any,                 big_sur:        "49857ba4da574bcbdf2795f9bed39ab9b9ca4c4b3d6ff39196b707f0981e8523"
    sha256 cellar: :any,                 catalina:       "c2beea84698794fc12896fa9e7b2c1655a3f4be189b90b6963799419ee3b34bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "eb5ddfcb456ade203f5d6a0d7bd721dab23b7a6ddb365125b358183323b75078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7efdf0c986f0afd7094a355256ee6743f2ce7720d23f680005e53a8ae5213244"
  end

  depends_on "pkgconf" => :build
  depends_on "jpeg-turbo"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  # Fixes: error: 'class Region2D<INDEX, SIZE>' has no member named 'DoesContainPoint'
  # https://sourceforge.net/p/mjpeg/patches/63/
  patch do
    url "https://sourceforge.net/p/mjpeg/patches/63/attachment/gcc-15.patch"
    sha256 "0bdaf8f7e584183d770925563ce065c8773f1ea7f5327ed2d62be19c6187cd8c"
  end

  def install
    system "./configure", "--enable-simd-accel", *std_configure_args
    system "make", "install"
  end
end
