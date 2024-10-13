class Nfdump < Formula
  desc "Tools to collect and process netflow data on the command-line"
  homepage "https://github.com/phaag/nfdump"
  url "https://github.com/phaag/nfdump/archive/refs/tags/v1.7.4.tar.gz"
  sha256 "8cf76ad0b4e3c1e7edf9532ec7508b11f125adcfcdac5010fd7eec8fe792cfd8"
  license "BSD-3-Clause"
  head "https://github.com/phaag/nfdump.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "e9c04f86eb62658e20cc3819e101b29b09ce7d12fcecd2c7889b9a8f61554d92"
    sha256 cellar: :any,                 arm64_sonoma:   "42fa76feef300134d762f24e8d44867855ad1f43641fec68998d39df23dce6cb"
    sha256 cellar: :any,                 arm64_ventura:  "543982b0fe73e4278ae50a28305e2503f6f0923114b0793e5f848a49055d6b92"
    sha256 cellar: :any,                 arm64_monterey: "798c9f5fa5609a306c20de9a6521792152aefd2e027f8144ec6f4a6a342aaca5"
    sha256 cellar: :any,                 sonoma:         "f1e1729415f6311951d6a910d1a616c0b608eec317285be862559cc735a92a92"
    sha256 cellar: :any,                 ventura:        "830e40010f31f0e9487b018b27b7a9539adec2d19d33b1a6c35c358e8b0eea41"
    sha256 cellar: :any,                 monterey:       "a9123fe3397f88570182367261c1c6b30a323e4da4a1427bcb200898149bcdb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64b660aaaa2bea081d802e32c32af4d2869b8a421cefb000467758b106f20847"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "bzip2"
  uses_from_macos "libpcap"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args, "--enable-readpcap", "LEXLIB="
    system "make", "install"
  end

  test do
    system bin/"nfdump", "-Z", "host 8.8.8.8"
  end
end
