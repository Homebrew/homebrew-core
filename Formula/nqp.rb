class Nqp < Formula
  desc "Lightweight Perl 6-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2021.10/nqp-2021.10.tar.gz"
  sha256 "48135bc1b3ce22c1c57ccef46531e7688eec83d6b905b502ffcefd6c23294b49"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_monterey: "fa8be8f0cd2637a23e450f2729c8610d434a2148079762680de1d6a7fe2be519"
    sha256 arm64_big_sur:  "d88b5bd9088506af32d032e087212734a9dd01c2e5d4055e2199a1fdd573a527"
    sha256 monterey:       "1d4f83aaa382a6480f9aa348d5aa7410a701f1bcec5d81aa1cd360eb9d75c199"
    sha256 big_sur:        "df4eef111e52728d766a4a645da78cc7e168df3a4e63f0c70ab6adcd3b1f5a4b"
    sha256 catalina:       "169de627fe293e3ddd52d65e76d0fc4ccb05506aa34a9c92fa9613ce86d8a511"
  end

  depends_on "libtommath"
  depends_on "moarvm"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with nqp included"

  def install
    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-moar=#{Formula["moarvm"].bin}/moar"
    system "make"
    system "make", "install"
  end

  test do
    out = shell_output("#{bin}/nqp -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    assert_equal "0123456789", out
  end
end
