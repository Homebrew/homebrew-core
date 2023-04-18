class Cdsclient < Formula
  desc "Tools for querying CDS databases for astronomical data"
  homepage "https://cdsarc.u-strasbg.fr/doc/cdsclient.html"
  url "http://cdsarc.u-strasbg.fr/ftp/pub/sw/cdsclient-3.84.tar.gz"
  sha256 "09eb633011461b9261b923e1d0db69d3591d376b447f316eb1994aaea8919700"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f027d41b9f8e25215f9babe4a1a577852e362d31faf12b69b2fe72d9b8378138"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fd5e3035379d99d397076e2cdbde8e2bd6de93ed901eed05171427d203d5c6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1231373935a305a1f9929ed4d1fc97cfc2f86def73835dc539f05e089c4deb2a"
    sha256 cellar: :any_skip_relocation, ventura:        "f5f05ab20a88a937a1bb818ccdf38338b1c247ab913dae5281e17da0ec2a9be7"
    sha256 cellar: :any_skip_relocation, monterey:       "8e943ed3346fdfc6f3ffd6d37331a9aba0429ec292e6a93fbf07108f2b0c4d24"
    sha256 cellar: :any_skip_relocation, big_sur:        "03cc1e6a05c20d4de1ac3a1cb43ca0da81066f8f474dcf1972c6c5af198eba62"
    sha256 cellar: :any_skip_relocation, catalina:       "fc9d0344c1ea4fc5e0cddc7a52d319ab65604aa2bdbd9d702866dd65e861f861"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c83214a0f91da5650dd051e619e4d10fc7a22517073cfbbb47506ab567f5659"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--libdir=#{lib}"
    man.mkpath
    system "make", "install", "MANDIR=#{man}"
    pkgshare.install bin/"abibcode.awk"
  end

  test do
    data = <<~EOS
      12 34 12.5 -34 23 12
      13 24 57.1 +61 12 34
    EOS
    assert_match "#...upload ==>", pipe_output("#{bin}/findgsc - -r 5", data, 0)
  end
end
