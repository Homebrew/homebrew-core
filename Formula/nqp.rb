class Nqp < Formula
  desc "Lightweight Perl 6-like environment for virtual machines"
  homepage "https://github.com/perl6/nqp"
  url "https://github.com/perl6/nqp/releases/download/2020.07/nqp-2020.07.tar.gz"
  sha256 "1bf941f10fc4eeef511ef0b6366f8c87a6327062c8400b44a8a148af3bb22a4e"
  license "Artistic-2.0"

  bottle do
    sha256 "282148386404a0eb1de8748d4f1cfc860159d43deefbd9d3b88dbe029b63fe0f" => :catalina
    sha256 "939d2184962c136540863db15733209cfeec4299ac24191903a4209f222bae8b" => :mojave
    sha256 "c8505229a909e9bc16855141b2350f99cfd67f0564e1816eebe0a55a50774c39" => :high_sierra
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
