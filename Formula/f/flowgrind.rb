class Flowgrind < Formula
  desc "TCP measurement tool, similar to iperf or netperf"
  homepage "https://flowgrind.github.io"
  url "https://github.com/flowgrind/flowgrind/releases/download/flowgrind-0.8.2/flowgrind-0.8.2.tar.bz2"
  sha256 "432c4d15cb62d5d8d0b3509034bfb42380a02e3f0b75d16b7619a1ede07ac4f1"
  license "GPL-3.0-or-later"
  revision 4

  livecheck do
    url :stable
    regex(/flowgrind[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dcd288a71292d550079710e54de9a1b51f45749548873121c5b93c876e60509e"
    sha256 cellar: :any,                 arm64_sequoia: "be6f606a92e205f42558c6af8de0f5ced370aa3dc4b3b1a872bea87135a683f8"
    sha256 cellar: :any,                 arm64_sonoma:  "5b6e921776fe31300df228841f92eae9051ec2d47b0f65641218de40a612896c"
    sha256 cellar: :any,                 sonoma:        "ffccc45ede3a5189617d45f4174a4651c8268a8d79c20efd9150a593d323612f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f3e749ef37e3609c899f5d6fc617045c2bc1c46b5f43c83d0b7c9edbf620e1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6c4eee0899191de5387f8210f2c3d4ba96313d50d82ee80e453546e60cfd1b7"
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
