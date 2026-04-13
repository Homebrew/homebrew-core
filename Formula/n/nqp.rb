class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2026.03/nqp-2026.03.tar.gz"
  sha256 "e7c15fcb5a77a6b5295dba68a9bd3a2d3151a66851e1f82f7e8e701741c97da5"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "ea68881e34a9d524a8bbdef5c171b9220a5ff8fe24764c92e5eb4f10a045b46f"
    sha256 arm64_sequoia: "682761b2fe795e52ce1b29f2569bbd45e9d7776b1f059525a9453dd2480e8c02"
    sha256 arm64_sonoma:  "c7232e3e537310f16fdf0f330a1d007dc03e21c7a79f3e05e38f3b27299f3f5f"
    sha256 sonoma:        "94a613dd17dad3e5c46e789323127c86a5b3f5ec17b6f66c1cc3d8f11c49cfec"
    sha256 arm64_linux:   "706c1b3e0dce1d6274587b653ce1e5994e5d25e66f0ad25aa47053eae414c014"
    sha256 x86_64_linux:  "dfa4ec35df58973b0fe5407f8279b9930b8c1d2edb0fcf8c7181fdc39d8728f0"
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
