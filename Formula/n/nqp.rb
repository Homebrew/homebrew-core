class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2024.04/nqp-2024.04.tar.gz"
  sha256 "cea588b0c7c0c03095541989383fef509b78f5ad4ab0657a32baeab6579b8ae9"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "65b3b69f2ace02f658683a423ed7108be1595e9495fc497b3da23411d5f494ab"
    sha256 arm64_ventura:  "0b3cf5dcc666ea71b093e74ede3c9513ab316ad66bffed039291bba57d1b6cbd"
    sha256 arm64_monterey: "1d1683af8013fd7313cfe2ad1aaedda26da9677bcfab0e699579dc3d6c1ea042"
    sha256 sonoma:         "7671c37be7aae6c0931543d8acb157d21899629f3c7e686b8d12005725e0c147"
    sha256 ventura:        "e79e67c44405a03ee2d00572406c6b94d0381c112b96d8d6b945562e93047d3a"
    sha256 monterey:       "22cdce3e3dda4eb2b033a1ac5553f53a19c4b2b6c0662d96abf08d260f5eb9a4"
    sha256 x86_64_linux:   "24b76326306a37bba92033ba474f1d8167a0ab8f1e571191339305589d82cd40"
  end

  depends_on "libtommath"
  depends_on "libuv"
  depends_on "moarvm"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

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
