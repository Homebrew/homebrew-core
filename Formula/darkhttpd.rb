class Darkhttpd < Formula
  desc "Small static webserver without CGI"
  homepage "https://unix4lyfe.org/darkhttpd/"
  url "https://github.com/emikulic/darkhttpd/archive/v1.13.tar.gz"
  sha256 "1d88c395ac79ca9365aa5af71afe4ad136a4ed45099ca398168d4a2014dc0fc2"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cf5e582aaab036d6a467b399416ec554c595f6b85187e76d43f57f2eb7dbbe3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36ae262543c3c5a76c282267e400ed1566cf31d1955f9a2d2298e2cb14a42cc8"
    sha256 cellar: :any_skip_relocation, monterey:       "34522ba6119c42022afeb73ef5b95a360d3293322c43af7d5e3edfc8034a5c8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "1643b2894325e4ed51b6007c1f1c6a935cc0780f48f3d953620d7b0ab50d6dbc"
    sha256 cellar: :any_skip_relocation, catalina:       "161992a2da584f5704fc6923d26fe6675a2ac23b3a66d9c1bba154b2a5888833"
    sha256 cellar: :any_skip_relocation, mojave:         "fdc947505f7ee3885b23431afe3603cb6e75f7edeea9784dab45975b30956086"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dddd097bfb71ec14118ed242beb0e7feb31012cb3888a9c6f5ed0c6ecdeda830"
  end

  def install
    system "make"
    bin.install "darkhttpd"
  end

  test do
    system "#{bin}/darkhttpd", "--help"
  end
end
