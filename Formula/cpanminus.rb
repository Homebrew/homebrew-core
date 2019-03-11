class Cpanminus < Formula
  desc "Get, unpack, build, and install modules from CPAN"
  homepage "https://github.com/miyagawa/cpanminus"
  url "https://github.com/miyagawa/cpanminus/archive/1.9019.tar.gz"
  sha256 "d0a37547a3c4b6dbd3806e194cd6cf4632158ebed44d740ac023e0739538fb46"
  head "https://github.com/miyagawa/cpanminus.git"

  bottle :unneeded

  def install
    cd "App-cpanminus" do
      bin.install "cpanm"
    end
  end

  test do
    system "#{bin}/cpanm", "Test::More"
  end
end
