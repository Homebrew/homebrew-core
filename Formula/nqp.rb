class Nqp < Formula
  desc "Lightweight Perl 6-like environment for virtual machines"
  homepage "https://github.com/perl6/nqp"
  url "https://github.com/perl6/nqp/releases/download/2020.02.1/nqp-2020.02.1.tar.gz"
  sha256 "f2b5757231b006cfb440d511ccdcfc999bffabe05c51e0392696601ff779837f"

  bottle do
    sha256 "58ca53d3d4cd2fecec525fbbe5a1da23e78900370481064be743525557e92b7b" => :catalina
    sha256 "c7bbe243cb54b11e19110e47019c1be8d8e4b22c6f19513a7cf18952b2f41811" => :mojave
    sha256 "a6ad4dc7f8e44023857ed5c3ba901c5f01088948d9cac38fdb113604aa58a060" => :high_sierra
  end

  depends_on "moarvm"

  conflicts_with "rakudo-star", :because => "rakudo-star currently ships with nqp included"

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
