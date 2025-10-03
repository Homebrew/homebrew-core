class Flowgrind < Formula
  desc "TCP measurement tool, similar to iperf or netperf"
  homepage "https://flowgrind.github.io"
  url "https://github.com/flowgrind/flowgrind/releases/download/flowgrind-0.8.2/flowgrind-0.8.2.tar.bz2"
  sha256 "432c4d15cb62d5d8d0b3509034bfb42380a02e3f0b75d16b7619a1ede07ac4f1"
  license "GPL-3.0-or-later"
  revision 3

  livecheck do
    url :stable
    regex(/flowgrind[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a49acd1bbdaf30610f77f42655dd282c32f99f969bb0e5678226005d17677179"
    sha256 cellar: :any,                 arm64_sequoia: "ca6a1f882f1e3d9d886000625a2b3f53f5ce0947f8d1581a9f4ccf1fd3e29b32"
    sha256 cellar: :any,                 arm64_sonoma:  "7fbd50a235fee0890cfcea2afe0a0ecaf6d95264ebb3bc804b2c0fe19bc47f5a"
    sha256 cellar: :any,                 arm64_ventura: "4cd194dededa538922c8776c32890c9c85241feca07ff12a4d6ef1c8ae74dbfc"
    sha256 cellar: :any,                 sonoma:        "3ec8f4b1038691864cf8fa30497efd7ede5191215f6b4812d11cce25e656a99e"
    sha256 cellar: :any,                 ventura:       "6e14c72f5e1674c8425b1fc2bbaaa31fe4a9abce2c57340c49610d19cc52f5dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c58295f14b80cb817de10f1693733ebb91126b2d030040c753d48eda23a5ba8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f3aa5e0fa120f60cb88c95cf2a710fa57e9481efe0b4067a694f96497b004f6"
  end

  head do
    url "https://github.com/flowgrind/flowgrind.git", branch: "next"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "gsl"
  depends_on "xmlrpc-c"

  uses_from_macos "libpcap"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"flowgrind", "--version"
  end
end
