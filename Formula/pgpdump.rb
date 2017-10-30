class Pgpdump < Formula
  desc "PGP packet visualizer"
  homepage "https://www.mew.org/~kazu/proj/pgpdump/en/"
  url "https://github.com/kazu-yamamoto/pgpdump/archive/v0.32.tar.gz"
  sha256 "b5cad57a07ba221049b168dd3baae54b03c6fdedcb4e9ce32e48f88cab01c305"
  head "https://github.com/kazu-yamamoto/pgpdump.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef4a74edd0241246acdb756482fcda11099579d0e17b00cfa3f9c00ea1410858" => :high_sierra
    sha256 "b36fd444b14191c517b3b8ef7450eba86f1497c6cb03647e7455464937c33f5f" => :sierra
    sha256 "fe7d869397fd41613acdf52f34902b191e71794a721dde327e8552b4acafaef1" => :el_capitan
    sha256 "9a67194a5fb26a28a7124330bf765ff3c4c54f05ab6e7750d3551403e567e9f7" => :yosemite
  end

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
