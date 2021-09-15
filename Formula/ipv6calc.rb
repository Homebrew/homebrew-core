class Ipv6calc < Formula
  desc "Small utility for manipulating IPv6 addresses"
  homepage "https://www.deepspace6.net/projects/ipv6calc.html"
  url "https://github.com/pbiering/ipv6calc/archive/3.2.0.tar.gz"
  sha256 "c73e1488a344d5ce3acdd009fb48068eec1bdf7562698011bdbbc7aaf33aa8f7"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8532274ecc261d17d7390821b9e8b432f56cdafe97ba34c583437b1fadfa7f27"
    sha256 cellar: :any_skip_relocation, big_sur:       "ee4ad9470fc4e89698937c724f1124d393289f6c3022a397cb3525562843fc53"
    sha256 cellar: :any_skip_relocation, catalina:      "032973accb1642b43fcf7320e8dd76e621c8024f3b6b0caf2fb24e69d90429d7"
    sha256 cellar: :any_skip_relocation, mojave:        "4a83aadc45974b755d94b59f2fd4e8fb4637139d527e4474122983a229731cb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "748772297ce211e30da123ccab4c9204738703e62cfe1ab90238dac434d9fb70"
  end

  def install
    # This needs --mandir, otherwise it tries to install to /share/man/man8.
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "192.168.251.97",
      shell_output("#{bin}/ipv6calc -q --action conv6to4 --in ipv6 2002:c0a8:fb61::1 --out ipv4").strip
  end
end
