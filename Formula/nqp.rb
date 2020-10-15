class Nqp < Formula
  desc "Lightweight Perl 6-like environment for virtual machines"
  homepage "https://github.com/perl6/nqp"
  url "https://github.com/perl6/nqp/releases/download/2020.08/nqp-2020.08.tar.gz"
  sha256 "a2b68c112adeb11e9ead3f63aa83249821d4c4b23d5f7c35c9effbafb2b4a128"
  license "Artistic-2.0"

  bottle do
    sha256 "41681920e178578ef3860b3cc5fbeeebafed1b97d563683cf01a5916fa685dac" => :catalina
    sha256 "c82fa7d1dc6349ff67c3396e31c1c3c0608968a56ad44cc06102226040825b00" => :mojave
    sha256 "8612375c8706eb4b3e42fe24145b190f4b6450e4c3563595a30229d8d55b848e" => :high_sierra
  end

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
