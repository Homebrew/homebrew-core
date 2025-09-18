class Libpcap < Formula
  desc "Portable library for network traffic capture"
  homepage "https://www.tcpdump.org/"
  url "https://www.tcpdump.org/release/libpcap-1.10.5.tar.gz"
  sha256 "37ced90a19a302a7f32e458224a00c365c117905c2cd35ac544b6880a81488f0"
  license "BSD-3-Clause"
  head "https://github.com/the-tcpdump-group/libpcap.git", branch: "master"

  livecheck do
    url "https://www.tcpdump.org/release/"
    regex(/href=.*?libpcap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "b240ed3c946844a508667f99c9827e3709daf8119018f526d22b3174e2764af7"
    sha256 cellar: :any,                 arm64_sequoia:  "2469721ab279d0e988bb6659dfd8bb3ab9317ca4ff20018eaa7a86f1749ba0e4"
    sha256 cellar: :any,                 arm64_sonoma:   "25f894b36f2bed3c1ec09f53b733cb79221e0264d0e995097c66a303815ac6ea"
    sha256 cellar: :any,                 arm64_ventura:  "8f55c62e20c74ecdcc8975ab8885659dd446bf6cf4b873f29695370de24b7815"
    sha256 cellar: :any,                 arm64_monterey: "1878536fd135dc9674a6c82f71f349bb7e4b57785aebaa419509b5ea1f90b89b"
    sha256 cellar: :any,                 sonoma:         "515263fb7383b3bc74e5976472d79097a979ac0a521b94c024b3701f133dbeee"
    sha256 cellar: :any,                 ventura:        "7792689ed0fb4e70cf87216b4e81dc20361c67ba6b7aa4a1531a445c54c69686"
    sha256 cellar: :any,                 monterey:       "042224e1182717afa4663273c410c7d9758ce60301d8ecfafb5096f4a2ae7f17"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "cab27b074b192f9489e7d588d9b6b96148eb4ba60afcd62149432baaab407bbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bc07f0a5bb3072c9f715cdb0799eaf1bd7a897c9ccc3373542845af931b4d32"
  end

  keg_only :provided_by_macos

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    # Exclude unrecognized options
    std_args = std_configure_args.reject { |s| s["--disable-debug"] || s["--disable-dependency-tracking"] }
    system "./configure", "--enable-ipv6", "--disable-universal", *std_args
    system "make", "install"
  end

  test do
    assert_match "lpcap", shell_output("#{bin}/pcap-config --libs")
  end
end
