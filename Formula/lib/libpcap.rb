class Libpcap < Formula
  desc "Portable library for network traffic capture"
  homepage "https://www.tcpdump.org/"
  url "https://www.tcpdump.org/release/libpcap-1.10.6.tar.gz"
  sha256 "872dd11337fe1ab02ad9d4fee047c9da244d695c6ddf34e2ebb733efd4ed8aa9"
  license "BSD-3-Clause"
  head "https://github.com/the-tcpdump-group/libpcap.git", branch: "master"

  livecheck do
    url "https://www.tcpdump.org/release/"
    regex(/href=.*?libpcap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "44f99c79e779b384423fc1177cd66cf1abadd9b3f4c8c51bd55f1843e95d6b1c"
    sha256 cellar: :any,                 arm64_sequoia: "bb2a05ed47e0c6fc8305d5c60bbd711ada65f4cc39382d0277b4a310d7698508"
    sha256 cellar: :any,                 arm64_sonoma:  "53e536f706ce763391ddd4b81cbdafe952dca8b32108539a6a7fe3abb10e871d"
    sha256 cellar: :any,                 sonoma:        "7f39af412e6e3508a96c3daa45c1b4e2b83dc7b3e6126ad3512942e448138777"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15596854dbfac794c2b5632077365596557cf4b66aea9dd222ef8bf9f901ca17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53b6667dfeb90b91b051a6ad7adcb97714c95b2196a2d155fc1ea79b5cbb09cd"
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
