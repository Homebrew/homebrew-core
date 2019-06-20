class F3 < Formula
  desc "Test various flash cards"
  homepage "http://oss.digirati.com.br/f3/"
  url "https://github.com/AltraMayor/f3/archive/v7.2.tar.gz"
  sha256 "ba9210a0fc3a42c2595fe19bf13b8114bb089c4f274b4813c8f525a695467f64"
  head "https://github.com/AltraMayor/f3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5636a946c64ba4439501aea19b355b441baae79d055d1ff94d5995cb51f77632" => :mojave
    sha256 "e283a7b888257fe37b70b7c836ef4244514efddbb4e346b349251b557e0ba5fc" => :high_sierra
    sha256 "97ce7a7c7224782e1a13059370faf14accba999ae8f9703a67174c9c67ec0bbb" => :sierra
    sha256 "35a9c1de5080318e2b2ff66623a120cee955f0ddd7b3ddab5b2fe3333791a041" => :el_capitan
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
