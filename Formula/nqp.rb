class Nqp < Formula
  desc "Lightweight Perl 6-like environment for virtual machines"
  homepage "https://github.com/perl6/nqp"
  url "https://rakudo.perl6.org/downloads/nqp/nqp-2019.03.tar.gz"
  sha256 "03ddced47583189a5ff316c05350f6f39c15f75ce44d38b409a4bb1128857fa0"

  bottle do
    sha256 "569cf43abc5112a08f1f55cb4f2649eca9f1a3f6191f5f91b6d01806534e06e1" => :mojave
    sha256 "e56cb5085cdd5223e6657d23deaba45f4f980aec52fc424ca2cccff91ceca165" => :high_sierra
    sha256 "0c0e3f3d6995c83b8b91f3a44a0222018d8dd8b2529dc1ed31547afe19c9129c" => :sierra
  end

  depends_on "moarvm"

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
