class Pgpdump < Formula
  desc "PGP packet visualizer"
  homepage "https://www.mew.org/~kazu/proj/pgpdump/en/"
  url "https://github.com/kazu-yamamoto/pgpdump/archive/v0.35.tar.gz"
  sha256 "50b817d0ceaee41597b51e237e318803bf561ab6cf2dc1b49f68e85635fc8b0f"
  license "BSD-3-Clause"
  head "https://github.com/kazu-yamamoto/pgpdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb05a1dc44518657f2782c5711291b642d1d756324128d16aadf0e8e2c778688"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e4edf88bafa923e819834e14aa930d28bec5bd5b8ac1e53b2be4d94dcc182ed"
    sha256 cellar: :any_skip_relocation, monterey:       "c58e12a52f46f1e86327930e6701245c1f4694ad3f2ba3c44cee9ac772c3043e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5ebd09d9b2d1c41dadfc7350b0db257d7c1e7577ca5229947ebb84b1859fe16"
    sha256 cellar: :any_skip_relocation, catalina:       "614447213dda6fb53aa1d9b7ffbdeb986cd87648c46a9a68e80c460d9aaaa77c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37d78f68ee709e17657c2117f9199c07c898a094e80497847e3b49af19cb7d19"
  end

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"sig.pgp").write <<~EOS
      -----BEGIN PGP MESSAGE-----
      Version: GnuPG v1.2.6 (NetBSD)
      Comment: For info see https://www.gnupg.org

      owGbwMvMwCSYq3dE6sEMJU7GNYZJLGmZOanWn4xaQzIyixWAKFEhN7W4ODE9VaEk
      XyEpVaE4Mz0vNUUhqVIhwD1Aj6vDnpmVAaQeZogg060chvkFjPMr2CZNmPnwyebF
      fJP+td+b6biAYb779N1eL3gcHUyNsjliW1ekbZk6wRwA
      =+jUx
      -----END PGP MESSAGE-----
    EOS

    output = shell_output("#{bin}/pgpdump sig.pgp")
    assert_match("Key ID - 0x6D2EC41AE0982209", output)
  end
end
