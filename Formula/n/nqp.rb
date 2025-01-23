class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2024.12/nqp-2024.12.tar.gz"
  sha256 "026ff25d7eaae299b2d644e46b389642774cdf51fd803047f4291731dc4b2477"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "9eaf460c5fb07c2780b79e6f0f209c63ccbc367456139b79f9805f7f42c7cb5f"
    sha256 arm64_sonoma:  "14c3ad615e905174ef54877e59ccb860a6247b91c8495df7159868ea66a41187"
    sha256 arm64_ventura: "b37e5d77916eab5dcc714be73443d79a6ae0f6466afe0944cf481d026e852caf"
    sha256 sonoma:        "b6ef1a5f9a8faf10a35c93583772cf0b931d298b75b6c8ed6734111810652b80"
    sha256 ventura:       "3d455c7c7b0efe06a90df4b351571a344d62e4739478f3577bfa621dc1bf4a2b"
    sha256 x86_64_linux:  "ff9384e7a67da0e5d22902204bceb0053e2266ebccedb8eca0a69e788a908491"
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
