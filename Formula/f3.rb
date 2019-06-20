class F3 < Formula
  desc "Test various flash cards"
  homepage "http://oss.digirati.com.br/f3/"
  url "https://github.com/AltraMayor/f3/archive/v7.2.tar.gz"
  sha256 "ba9210a0fc3a42c2595fe19bf13b8114bb089c4f274b4813c8f525a695467f64"
  head "https://github.com/AltraMayor/f3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5830e81dc3a83ed4ad4b2955d1775e63367d68a815299f99b7556cfe4aca38f7" => :mojave
    sha256 "725c7f88756ea641e75796949e5c59fa7040a97b5ae6f8fd1e580a77a50cd0b6" => :high_sierra
    sha256 "04f2d3dee579c8740b23f48f7df4160f2e680d92afb4f887bba65f87b804ed93" => :sierra
  end

  depends_on "argp-standalone"

  def install
    system "make", "all", "ARGP=#{Formula["argp-standalone"].opt_prefix}"
    bin.install %w[f3read f3write]
    man1.install "f3read.1"
    man1.install_symlink "f3read.1" => "f3write.1"
  end

  test do
    system "#{bin}/f3read", testpath
  end
end
