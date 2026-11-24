class Libpcap < Formula
  desc "Portable library for network traffic capture"
  homepage "https://www.tcpdump.org/"
  url "https://www.tcpdump.org/release/libpcap-1.11.1.tar.gz"
  sha256 "7985b1d20ff82c1e384115038046e0b15034648c6f45c92e08601d4ee1b369ed"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/the-tcpdump-group/libpcap.git", branch: "master"

  livecheck do
    url "https://www.tcpdump.org/release/"
    regex(/href=.*?libpcap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "defb78c7cc726546238be9872bf17f8cf0192dbb714d5a0858fda4790e360b72"
    sha256 cellar: :any, arm64_golden_gate: "6b8ed6d22569377dceea80ac982aa73af4f22b3df209025126f5ff726a5861af"
    sha256 cellar: :any, arm64_tahoe:       "1caacb542aaa5a0206ad44c3485284756375a9b180c19bc7916f5f622c395874"
    sha256 cellar: :any, arm64_sequoia:     "08fecce605ad219eaf3c3193ec2f607964de79de782794d8efa3ee9d04068a74"
    sha256 cellar: :any, arm64_linux:       "c681e19e50fb74303f3f9a5414546cdb5fb72a1574352e4e6379a47a475d2e71"
    sha256 cellar: :any, x86_64_linux:      "0adfa9c6eaf5bc634bcd66ceed632d1722af2219ce4826071e6321eea5f15255"
  end

  keg_only :provided_by_macos

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  deny_network_access!

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
