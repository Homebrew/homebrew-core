class F3 < Formula
  desc "Test various flash cards"
  homepage "http://oss.digirati.com.br/f3/"
  url "https://github.com/AltraMayor/f3/archive/v7.1.tar.gz"
  sha256 "1d9edf12d3f40c03a552dfc3ed36371c62933b9213483182f7a561e1a5b8e1cc"
  head "https://github.com/AltraMayor/f3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d369cb856bab428b9bf17049f0331ad9c1a7154088433887ec141054bb4bab74" => :high_sierra
    sha256 "e11bf7b13aba7ad198486aca8a3edccae5fbaaedff47d6b51f0147cbac4a5d04" => :sierra
    sha256 "47474e4cab315cf4f3dd124a133fc17f4547e7cb111d630e79131ea1f572f36f" => :el_capitan
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
