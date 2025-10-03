class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2025.08/nqp-2025.08.tar.gz"
  sha256 "d7d6b42834fb81feeb6b6f0dc77174ebb50b827a3897e852fae68c0ae5614638"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "47f500beb7436a51f2cb09925f4515898e6c613869989c3377a33fe451593056"
    sha256 arm64_sequoia: "3f83f750ea6139c5c22000c0bf95551f7bce17ed64619011e9ea88c2ace06901"
    sha256 arm64_sonoma:  "8de5f0370711ac2ecd0e4140c514dd77f5f9c3a9541882fb57e59937f8776a84"
    sha256 arm64_ventura: "825cc40b240f886e438e5daf4c0413858e99c5ccda38d0d28886f58b0edf46b2"
    sha256 sonoma:        "2c81f99b2035a9d273ea9bf62e09a3f0d43f596bc368536fb07120d40ac7a16a"
    sha256 ventura:       "d8815c48ee2b126f5688f064ebbf6d2fda48d6479af71f34d14792dbfccdc547"
    sha256 arm64_linux:   "791efb46c68dae9cd3381bbae60ca33a7b175f949f27b65b61299b2a8bb5a631"
    sha256 x86_64_linux:  "e287d9192c3d7ad5709e5d43fa3edeb47b197af16b412b3f2312f149eddc7fe5"
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
