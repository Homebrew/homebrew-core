class Cpanminus < Formula
  desc "Get, unpack, build, and install modules from CPAN"
  homepage "https://github.com/miyagawa/cpanminus"
  url "https://github.com/miyagawa/cpanminus/archive/1.7042.tar.gz"
  sha256 "ec814986cfbb6dc5db9dd7b20de2b3e9b8da46c170854b110cd5d404b4e46974"
  head "https://github.com/miyagawa/cpanminus.git"

  bottle :unneeded

  def install
    bin.install "cpanm"
  end

  test do
    system "#{bin}/cpanm", "Test::More"
  end
end
