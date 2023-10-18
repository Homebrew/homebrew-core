class Libpcap < Formula
  desc "Portable library for network traffic capture"
  homepage "https://www.tcpdump.org/"
  url "https://www.tcpdump.org/release/libpcap-1.10.4.tar.gz"
  sha256 "ed19a0383fad72e3ad435fd239d7cd80d64916b87269550159d20e47160ebe5f"
  license "BSD-3-Clause"
  head "https://github.com/the-tcpdump-group/libpcap.git", branch: "master"

  livecheck do
    url "https://www.tcpdump.org/release/"
    regex(/href=.*?libpcap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9bcecfe2faea9a6a3f1361792150add6a8a9d0e0d210f60e6e2d75221b09f76a"
    sha256 cellar: :any,                 arm64_ventura:  "c9ab92960280af2f6677af5adac6400c0fcbc989e10c82539abd5e6fa07ace6c"
    sha256 cellar: :any,                 arm64_monterey: "57cf3e889d51c5fb5b7a9337080efcae4580f6903c2c6bfe428da8f3149d9da3"
    sha256 cellar: :any,                 arm64_big_sur:  "8229a0d02cb1294ca286d70aa197c439b60270a64b08985127b2c85e28c34062"
    sha256 cellar: :any,                 sonoma:         "f1270a86135dcf0b112b622ca73f4cef4a0fcd5acc24014d5d9e3f3ddb7f9ad8"
    sha256 cellar: :any,                 ventura:        "b9e4f0cfacd43b79b0966420ec5306920847ffca235efc22cdf566765b2fb37a"
    sha256 cellar: :any,                 monterey:       "f7883aecab73688e915f71f86d1c0def30f8ed2b316a557412761dc106d65652"
    sha256 cellar: :any,                 big_sur:        "28ce01f0924dc297d43fb493929d9dd0ecc8235f7e1fe5797652a4f14be9b60d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ecc72e233bad9575bf92185d05b526ecae130e0598cf47613ce472fd3dc73aa"
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
