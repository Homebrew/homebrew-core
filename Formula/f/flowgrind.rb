class Flowgrind < Formula
  desc "TCP measurement tool, similar to iperf or netperf"
  homepage "https://flowgrind.github.io"
  url "https://github.com/flowgrind/flowgrind/releases/download/flowgrind-0.8.2/flowgrind-0.8.2.tar.bz2"
  sha256 "432c4d15cb62d5d8d0b3509034bfb42380a02e3f0b75d16b7619a1ede07ac4f1"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/flowgrind[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9d67573534b44e82d9e3b6cb7dd4f01f8262b186b881451f7e93345c48da3e26"
    sha256 cellar: :any,                 arm64_ventura:  "32ae737968e3ec8f7ff3050fdaa05997f577449240eebcce04c167ed2d8ee8ca"
    sha256 cellar: :any,                 arm64_monterey: "a3b2153eabe2aa604c8f76f65f024519aaa92ae3de4c9370ac51eb2aa1df503c"
    sha256 cellar: :any,                 sonoma:         "225e6711feb00d2a0d4de72c90159bc6c3fd5431395bb701b3306788c7c262ac"
    sha256 cellar: :any,                 ventura:        "23d78af4f75a7f5b38fd0a9ae386b0aed5fb3a402b2eebeabb0adb2ac2612807"
    sha256 cellar: :any,                 monterey:       "9f9ceddf04bb8ea8fdc22217b47a3ee2a52c4cb1125e32840d4cceaabe9503ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79a7c1035ff844d84e19db85437fcb71458dbb11da7daca67aad5290d6a2d28d"
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
    system "#{bin}/flowgrind", "--version"
  end
end
