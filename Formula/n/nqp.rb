class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2026.01/nqp-2026.01.tar.gz"
  sha256 "6bb80256bc5274a2a89eac9b86fe8dd808b25657cf460ea0d3d847958ba54b25"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "59c2bf779d40013edf5cf11d2a7014c388d178222a82a626c83cb5b36d399ad9"
    sha256 arm64_sequoia: "05d7d55b6f110101a87bf5df45b7d478cf4c97ab03d2d47170f0dfd9f7f1bb07"
    sha256 arm64_sonoma:  "45cd8615fa1c624bcfe121adff01c06c2b6a0fdbba8fa990f288e3aac9a72865"
    sha256 sonoma:        "3bfe692872b7c6fd56b175900fa417c1c8bb6d0e24e42ad1d318437598b5aa19"
    sha256 arm64_linux:   "895e45cd2e74e942f9ef64a3a573bfc8cbbbbfdfb64a0e83c028241eafd678a5"
    sha256 x86_64_linux:  "2e24c91eda0c844a7c75b7e2c4b370425c3e40657f8441749f2a167417e53a31"
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
