class Lsix < Formula
  desc "Shows thumbnails in terminal using sixel graphics"
  homepage "https://github.com/hackerb9/lsix"
  url "https://github.com/hackerb9/lsix/archive/refs/tags/1.9.1.tar.gz"
  sha256 "310e25389da13c19a0793adcea87f7bc9aa8acc92d9534407c8fbd5227a0e05d"
  license "GPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "1236a71809bd24fd1cedb055f51286a8af6ce959d54c6669b8849eee706b050e"
  end

  depends_on "bash"
  depends_on "imagemagick"

  def install
    bin.install "lsix"
  end

  test do
    output = shell_output "#{bin}/lsix 2>&1"
    assert_match "Error: Your terminal does not report having sixel graphics support.", output
  end
end
