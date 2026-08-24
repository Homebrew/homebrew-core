class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2026.08/nqp-2026.08.tar.gz"
  sha256 "120de1ac6f3246e7c5d04261ef18e64d9c3663f6670e952528d0d5c04b889cf2"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "9245bbbcd84edb8bad5756d8c1d3e67705e556665f005ba575a728aab2ef3b6d"
    sha256 arm64_sequoia: "dd64876d11bbd7c7c2cd5eafc819ff32e2ef12eb66f815fa6b546400ffa6496f"
    sha256 arm64_sonoma:  "3f7b32a8a0b2684245e85f3d7b5bdb3222842fe928ff74ba97d31c65926ec635"
    sha256 sonoma:        "c1c4ba1e17e4f2f4e76f08d0182350112bc58aaf349a4df800fc2a7224a9c7eb"
    sha256 arm64_linux:   "a677f16c648c31065f03be8f92a0d85efc9138483a6e5dd4ecbee3a0c1b65f09"
    sha256 x86_64_linux:  "99579f04945d17aadf3ecc4f2d8b07fa1f590c8b391487f0a7a5cb4fec2b9f19"
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
