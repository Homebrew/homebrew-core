class Cpanminus < Formula
  desc "Get, unpack, build, and install modules from CPAN"
  homepage "https://github.com/miyagawa/cpanminus"
  url "https://github.com/miyagawa/cpanminus/archive/1.7043.tar.gz"
  sha256 "7f52a6487a2462b658164f431ae6cc0b78685df3bccfe4139823372cb5b5fd42"
  head "https://github.com/miyagawa/cpanminus.git"

  bottle :unneeded

  def install
    bin.install "cpanm"
  end

  test do
    system "#{bin}/cpanm", "Test::More"
  end
end
