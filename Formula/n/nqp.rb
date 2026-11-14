class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2026.11/nqp-2026.11.tar.gz"
  sha256 "a40d60b0062925e6e09d4fed219dafb2b9d23df22052a445a61790aa0bdbaad5"
  license "Artistic-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "a1f0d6e34e555af2649823cdc21c9ec470c66ddac4eb205dc3c6c0d5fee03ba1"
    sha256 arm64_tahoe:       "2039b4d3e9f7a30b7dfb3e89a96eabe1c8a857c8c2e93c7951046d5dfc4f90f8"
    sha256 arm64_sequoia:     "7dc37875613e8bc3c0f844a1a3987f6bf4986969ddd1d9055e695b67c38ba041"
    sha256 arm64_linux:       "205fb033e0886a79067980caee64508a49b120907a047150daa19fa2bd27c57d"
    sha256 x86_64_linux:      "21aa9898d5cbed8c2b23fc8e52f3227b0b881eabcd40611465d0fdb8641e94c4"
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
                   "--with-moar=#{formula_opt_bin("moarvm")}/moar"
    system "make"
    system "make", "install"
  end

  test do
    out = shell_output("#{bin}/nqp -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    assert_equal "0123456789", out
  end
end
