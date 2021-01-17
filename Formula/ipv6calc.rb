class Ipv6calc < Formula
  desc "Small utility for manipulating IPv6 addresses"
  homepage "https://www.deepspace6.net/projects/ipv6calc.html"
  url "https://github.com/pbiering/ipv6calc/archive/3.0.2.tar.gz"
  sha256 "509e5456ed76e143b05adece1180fe78f09f4b8526e0c3cbf0c9f0188207b160"
  license "GPL-2.0-only"

  bottle do
    cellar :any_skip_relocation
    sha256 "99ced07c468237c7b359fb09a4af9a99704b1064d6ff880d7788b1a2b21c58f0" => :big_sur
    sha256 "e06b38613ae4e22bf498536a83be33e896075905f1852e2823a41ae978f30589" => :arm64_big_sur
    sha256 "1bb2265e7c8083326a10a0ed7c4dd753a338562824299dca4fcfc0a1eb7c1f23" => :catalina
    sha256 "204b67b41e69af62b8abd836309be74e44136f190a784cd5dbeeb3f84fef3c25" => :mojave
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
