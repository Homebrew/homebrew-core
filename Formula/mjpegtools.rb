class Mjpegtools < Formula
  desc "Record and playback videos and perform simple edits"
  homepage "https://mjpeg.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mjpeg/mjpegtools/2.2.1/mjpegtools-2.2.1.tar.gz"
  sha256 "b180536d7d9960b05e0023a197b00dcb100929a49aab71d19d55f4a1b210f49a"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6617edf8918a64e1850a6b94627617a460dc85234bf56c2c4f0af9bd77608d3f"
    sha256 cellar: :any,                 arm64_monterey: "c7d05e5fc6d485aa298f4aa7ce6cdfb0c28f2a7792650bba2e3fda8adc030f85"
    sha256 cellar: :any,                 arm64_big_sur:  "35bd5112b5352ad73c9636e205134628682d93f2502d33951945f676464f1e72"
    sha256 cellar: :any,                 ventura:        "1e9e03514b9817e89ed635a9657bb226a3582b52765511e8a8fd36f5a7208ced"
    sha256 cellar: :any,                 monterey:       "9afd34745954ea736c8e894c42b4552aa414df0d44942a09d7c47a6113c3ed2b"
    sha256 cellar: :any,                 big_sur:        "49857ba4da574bcbdf2795f9bed39ab9b9ca4c4b3d6ff39196b707f0981e8523"
    sha256 cellar: :any,                 catalina:       "c2beea84698794fc12896fa9e7b2c1655a3f4be189b90b6963799419ee3b34bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7efdf0c986f0afd7094a355256ee6743f2ce7720d23f680005e53a8ae5213244"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg-turbo"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", *std_configure_args, "--enable-simd-accel"
    system "make", "install"
  end
end
