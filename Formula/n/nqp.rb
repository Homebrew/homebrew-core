class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2026.02/nqp-2026.02.tar.gz"
  sha256 "63d151194d634accb373b73fb734413a4a143a7248e530b75ca686f3f68e2539"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "399ba2cc8d39bbfcc81ff8832dd4dbac1418b2b151e0adbd3f0c2292926fd582"
    sha256 arm64_sequoia: "69df7eb62c5ce3eabd3623d29ccd47556b8e01d43730523c97eb320138261832"
    sha256 arm64_sonoma:  "738c51fb2bef6149c24758ed1e48f3534e7dab68c7adcb74b0ddc5e1cf75601e"
    sha256 sonoma:        "d61ad50f9dacc682ba65e4db03757039e6c8fa46a5addc1407c808feba63e3ad"
    sha256 arm64_linux:   "fccfa200a90d81557bedcb9d36ef0a761f093862b0d8573e4b8e0da2811244b4"
    sha256 x86_64_linux:  "d292d88ad7556987ebb647916c296504d02585aba0bf43f1641ddff7c2639be8"
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
