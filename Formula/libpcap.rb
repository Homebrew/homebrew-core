class Libpcap < Formula
  desc "Portable library for network traffic capture"
  homepage "https://www.tcpdump.org/"
  url "https://www.tcpdump.org/release/libpcap-1.10.0.tar.gz"
  sha256 "8d12b42623eeefee872f123bd0dc85d535b00df4d42e865f993c40f7bfc92b1e"
  license "BSD-3-Clause"
  head "https://github.com/the-tcpdump-group/libpcap.git"

  livecheck do
    url "https://www.tcpdump.org/release/"
    regex(/href=.*?libpcap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "72a38b8e85b06f8415672be7add4df263cb5aee7f7c5e585f0c470283d425344" => :big_sur
    sha256 "0de7ac1cef6b44f5b007c22e4b1a6a42d4e93e570b1acb07f43d11b4e19c1ee0" => :arm64_big_sur
    sha256 "3a85693ff5d241ccdc689af9fa1281434ddf6ae3d0887cd679d07bbc1730ec29" => :catalina
    sha256 "57ec7b7a786335d818c7eaca81a834c5ca9f4865a91df78b621d6b5d586cf859" => :mojave
    sha256 "26028b66ea5395a0eee75ebd5790e9d3a688e83698631aec328224bb7baa6037" => :high_sierra
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
    assert_match /lpcap/, shell_output("#{bin}/pcap-config --libs")
  end
end
