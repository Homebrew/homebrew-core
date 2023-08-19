class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.18.1/libfabric-1.18.1.tar.bz2"
  sha256 "4615ae1e22009e59c72ae03c20adbdbd4a3dce95aeefbc86cc2bf1acc81c9e38"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "aa139bf21677b846cdeef941f6dc1523e85356a707ec81bf02f7210cce00a9d8"
    sha256 cellar: :any,                 arm64_monterey: "0cd9af45539d17f33d1a8513bdc07fbb434cf6a08114e3929e70e3c5b56fce24"
    sha256 cellar: :any,                 arm64_big_sur:  "eb6fb70777a9f2ddb0f88b8034c1ff80b8b4a7cd9704166f83b9e40bbf36fc9c"
    sha256 cellar: :any,                 ventura:        "02506fe3395582dc5545c839a9e68f136dd677e4cb519f6d9a54feae5c6f2b2e"
    sha256 cellar: :any,                 monterey:       "73b68d4c765f28d948a7dc3f438c64639d76f86525b48716f10eedae1691a872"
    sha256 cellar: :any,                 big_sur:        "a40eff1dcae0d84217799f6380a50b51d0549aa31d8b80542ed954640687185c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c75b21612e1a667fd5a918bac971817952b580f7f3ac85eb5fb8a1b7be74b79e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build

  on_macos do
    conflicts_with "mpich", because: "both install `fabric.h`"
  end

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "provider: sockets", shell_output("#{bin}/fi_info")
  end
end
