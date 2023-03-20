class Libpcap < Formula
  desc "Portable library for network traffic capture"
  homepage "https://www.tcpdump.org/"
  url "https://www.tcpdump.org/release/libpcap-1.10.3.tar.gz"
  sha256 "2a8885c403516cf7b0933ed4b14d6caa30e02052489ebd414dc75ac52e7559e6"
  license "BSD-3-Clause"
  head "https://github.com/the-tcpdump-group/libpcap.git", branch: "master"

  livecheck do
    url "https://www.tcpdump.org/release/"
    regex(/href=.*?libpcap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3df35be270b8bd17d0cd91e43c10b66870c45034e75707d6b6cdf7d5dd38a72b"
    sha256 cellar: :any,                 arm64_monterey: "0483ea9943b771c1844e3e889b09bd786b796e615905516f28a20fab44bb41e7"
    sha256 cellar: :any,                 arm64_big_sur:  "04e430f3cac412855961560d189ff362e089de0800849a5bcc89ca195a292337"
    sha256 cellar: :any,                 ventura:        "e13d617d00b48e6f37bbf66e50f99d02f3770373456c4c4a16422c1eb84474b3"
    sha256 cellar: :any,                 monterey:       "8809d53d2864fead641bffa8183b51166a25a177b88fc555fe0176f2e1d3afc9"
    sha256 cellar: :any,                 big_sur:        "0b4f05d3e0fd1b56de4e31f7f5f66f3e1ddbf62d779d4bbadce5d19f39eaff51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62b980944a6b87ca058b5dd77fccb7032b3762df6bf64d2311a93365a581e2ce"
  end

  keg_only :provided_by_macos

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-ipv6",
                          "--disable-universal"
    system "make", "install"
  end

  test do
    assert_match "lpcap", shell_output("#{bin}/pcap-config --libs")
  end
end
