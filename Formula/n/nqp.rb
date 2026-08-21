class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2026.07/nqp-2026.07.tar.gz"
  sha256 "f1371190487873d55f0d1920dfed10d9623393c48b5b6ca34b96d6048ad22acc"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "9be8f02613da480f00c98df58a7a5b365d145ac515e0553528e8153f9f5a2f7c"
    sha256 arm64_sequoia: "da9128125b7304084bfaf1a4879e707eff13a59a9ce355f75209c1905161e833"
    sha256 arm64_sonoma:  "fa8f89e98a0f5735d117ce135a5904c653e6a360789fec498222e6c1b593a1e2"
    sha256 sonoma:        "473384776c8963d32ffa92986dc2977b1fa2119f203abdd4586381d80b4c528e"
    sha256 arm64_linux:   "2e590be65d6635eaaf6d693b5c19abbf6d46b1015125da62e38ebe02db4854cb"
    sha256 x86_64_linux:  "019def74a9aab084c490aef6ef4587103756c76234b84f6921e6942f7a4d1f20"
  end

  depends_on "moarvm"

  uses_from_macos "perl" => :build

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with nqp included"

  def install
    ENV.deparallelize

    # Work around Homebrew's directory structure and help find moarvm libraries
    inreplace "tools/build/gen-version.pl", "$libdir, 'MAST'", "'#{Formula["moarvm"].opt_share}/nqp/lib/MAST'"

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
