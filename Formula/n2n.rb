class N2n < Formula
  desc "Peer-to-peer VPN"
  homepage "https://www.ntop.org/products/n2n/"
  url "https://github.com/ntop/n2n/archive/2.4.tar.gz"
  sha256 "acbf5792935b84fb6516b9a2133a0f6f70023ee6ee4ca0d2d4248cab187f3c04"

  depends_on "openssl"

  def install
    system "make"
    system "make", "test"
    system "make", "PREFIX=#{prefix}", "install"
  end

  def caveats
    <<~EOS
      A virtual network interface is needed. You may install one with Homebrew Cask:
        brew cask install tuntap
    EOS
  end

  test do
    system "#{sbin}/edge", "-h"
  end
end
