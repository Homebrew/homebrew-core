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
    sha256 arm64_golden_gate: "f45754adaa4d1a2e2a5692daab29a8a1c3dbe94c57428d21265b790ad462cf61"
    sha256 arm64_tahoe:       "e88e49cce4da7327d2067501fe2e5e1baa8fea4de36aa9a5d7e9d21421dfa153"
    sha256 arm64_sequoia:     "d72e3debf93630b768a810b370469fc4bfe17fdcb4c0bf271fc7baee561b77a4"
    sha256 arm64_linux:       "8966b68c78302ce1edadfafff4c2512a08a0f0b4b32adc68b21acd3c5ae6944d"
    sha256 x86_64_linux:      "526109e54edd30bd95a032d0f247f58bd84d5577ff63cbf29f72f47da49a4876"
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
