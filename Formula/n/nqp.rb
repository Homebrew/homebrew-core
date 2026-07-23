class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2026.06/nqp-2026.06.tar.gz"
  sha256 "51514df4be087d4bf767eb8eb594363a699962a5ad759a4a8a50d07b9b0af13e"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "005e4bb23d8b44061972522dea5e4e63fb155b65e1c45a96ced6a755ea1a04b0"
    sha256 arm64_sequoia: "dc79e363c1eae96eff0251ff97a4ae4bf0286a688428470f06b5c9f69e9989c5"
    sha256 arm64_sonoma:  "fafe5490e68ab20f113ae4eb82db4ee0ca5b109236d74f0ee40a224c7e58de73"
    sha256 sonoma:        "561a29ead5b3d7984fa20e497ce374650fba5aed2da8522187b5b33b3f52e8e7"
    sha256 arm64_linux:   "8482d3ef3fce7edf9a473b2158bb18f4bba164eb8d57bc83ecf6c2a977c62f9b"
    sha256 x86_64_linux:  "b613f98346879b76f438f2a65832d79f17a8d9b4982e974fbf4023d9e1f8bb68"
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
