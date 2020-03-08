class Nqp < Formula
  desc "Lightweight Perl 6-like environment for virtual machines"
  homepage "https://github.com/perl6/nqp"
  url "https://github.com/perl6/nqp/releases/download/2020.01/nqp-2020.01.tar.gz"
  sha256 "4ccc9c194322c73f4c8ba681e277231479fcc2307642eeeb0f7caa149332965b"

  bottle do
    sha256 "ea972f125bb601106b454b3f1596b7e2aa7b3650487dcdda21e193be82af6943" => :catalina
    sha256 "12f89f3523ab33211eaf9db859ffcae0aa774efa4a45c68993d17b49a062f579" => :mojave
    sha256 "5745de9144151d32539d14da3bc1d0407bf2360749bf54978b3775bd827fad6f" => :high_sierra
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
