class Cpanminus < Formula
  desc "Get, unpack, build, and install modules from CPAN"
  homepage "https://github.com/miyagawa/cpanminus"
  url "https://github.com/miyagawa/cpanminus/archive/1.7044.tar.gz"
  sha256 "a5407a85c2f3dda74dfc2241c68dafb9951f2a6eeada0a0eea9e7238a482c195"
  head "https://github.com/miyagawa/cpanminus.git"

  bottle :unneeded

  def install
    bin.install "cpanm"
  end

  test do
    system "#{bin}/cpanm", "Test::More"
  end
end
