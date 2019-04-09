class Ipv6calc < Formula
  desc "Small utility for manipulating IPv6 addresses"
  homepage "https://www.deepspace6.net/projects/ipv6calc.html"
  url "https://github.com/pbiering/ipv6calc/archive/2.0.0.tar.gz"
  sha256 "a72c78c72e004ec91e62a4d251191621bb17ac89391a59ee2877f43f81f1810c"

  bottle do
    cellar :any_skip_relocation
    sha256 "05f50f0400695159e0ea1ad3b3319c9730b5ec3a447f708fc64dc828ac945a24" => :mojave
    sha256 "523ff4095824ee3755c2345e7d566ffaf5e744e6460776ba9ce0f15c2a9b54af" => :high_sierra
    sha256 "7be44273bca8f54e2b6a17313842287ae7f5b2b14a04f40c3b71bf00c348f2e5" => :sierra
  end

  def install
    # This needs --mandir, otherwise it tries to install to /share/man/man8.
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "192.168.251.97", shell_output("#{bin}/ipv6calc -q --action conv6to4 --in ipv6 2002:c0a8:fb61::1 --out ipv4").strip
  end
end
