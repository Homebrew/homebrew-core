class ProxychainsNg < Formula
  desc "Hook preloader"
  homepage "https://sourceforge.net/projects/proxychains-ng/"
  url "https://github.com/rofl0r/proxychains-ng/archive/v4.14.tar.gz"
  sha256 "ab31626af7177cc2669433bb244b99a8f98c08031498233bb3df3bcc9711a9cc"
  head "https://github.com/rofl0r/proxychains-ng.git"

  bottle do
    sha256 "1b8b781209633d9c4c45249b78865311e9853c36ba8522146a95cf4793d166b1" => :catalina
    sha256 "4b41340fc2a68c579b3ab30affbe82f9be545537f727507d19977b1b67193a96" => :mojave
    sha256 "42ba51b1578ff901987212d74e8b3a83ec6313f5ccfe3d554a9b32766f9b65c4" => :high_sierra
    sha256 "4c8e8c69bd10529a33b3f70e1a55504f79e3358fe834d521c95adafb2f4eea4a" => :sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make"
    system "make", "install"
    system "make", "install-config"
  end

  test do
    assert_match "config file found", shell_output("#{bin}/proxychains4 test 2>&1", 1)
  end
end
