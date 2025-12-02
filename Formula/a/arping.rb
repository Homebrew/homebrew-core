class Arping < Formula
  desc "Utility to check whether MAC addresses are already taken on a LAN"
  homepage "https://github.com/ThomasHabets/arping"
  url "https://github.com/ThomasHabets/arping/archive/refs/tags/arping-2.26.tar.gz"
  sha256 "58e866dce813d848fb77d5e5e0e866fb4a02b55bab366a0d66409da478ccb12f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "33a1adf38137a9ba246ad985987abb3f87bf649a9e07498d0720184bc07a5c4d"
    sha256 cellar: :any,                 arm64_sequoia: "a7859260b1ee1211710c85a796a4946e351303d41b12438a4efbb90671f6bb79"
    sha256 cellar: :any,                 arm64_sonoma:  "c1947a1d941c8a2192b8ec97f93622df09601f44b184a8ccdcc0bc20bdf05032"
    sha256 cellar: :any,                 arm64_ventura: "180e181d122742cff589f2704d479e3691fcd644b973f8c3ad3ec3d28baac79f"
    sha256 cellar: :any,                 sonoma:        "93391c9235609d122da03039bf6ca8d4a94025498f1ce80e3df8a620cb074bc8"
    sha256 cellar: :any,                 ventura:       "3b7c88773c4f21c3308ab62ae6c2459fb661b70154d207789c591bdb233f68af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53b81354c772f4ccdce0a2207abd75cc6cb8bcd64323e8c8f55411a3060d97b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d47eea83f17a1a41a3dce0461f3ea8d53869c1aa6a1292f7c3d59e46debdce2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libnet"

  uses_from_macos "libpcap"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/arping", "--help"
  end
end
