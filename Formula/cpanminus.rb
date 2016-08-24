class Cpanminus < Formula
  desc "Get, unpack, build, and install modules from CPAN"
  homepage "https://github.com/miyagawa/cpanminus"
  url "https://github.com/miyagawa/cpanminus/archive/1.9003.tar.gz"
  sha256 "2756aa182657e3ada01aa5abd018ae180186196e9a0ef00dfb04b279c307a3c6"
  head "https://github.com/miyagawa/cpanminus.git"

  bottle :unneeded

  def install
    bin.install "cpanm"
  end

  test do
    system "#{bin}/cpanm", "Test::More"
  end
end
