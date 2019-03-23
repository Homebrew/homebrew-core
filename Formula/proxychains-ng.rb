class ProxychainsNg < Formula
  desc "Hook preloader"
  homepage "https://sourceforge.net/projects/proxychains-ng/"
  url "https://github.com/rofl0r/proxychains-ng/archive/v4.14.tar.gz"
  sha256 "ab31626af7177cc2669433bb244b99a8f98c08031498233bb3df3bcc9711a9cc"
  head "https://github.com/rofl0r/proxychains-ng.git"

  bottle do
    sha256 "9d1d0ca3e57ab91965b863c2bf350242ef65bf7d7de275c19c01f29a9ea5d506" => :mojave
    sha256 "71c967d3a664d42441ccd0917e4c47f58a5077c4e316279b9960529733826ac0" => :high_sierra
    sha256 "231b56ce95d2df4d3949f919176033afca0ad5ac80250ee73fbdad5c2ee2709d" => :sierra
    sha256 "211eff05f188af0e1555b44d0d93fce74458f5018280a9e1e02007c61192511c" => :el_capitan
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
