class Pgpdump < Formula
  desc "PGP packet visualizer"
  homepage "https://www.mew.org/~kazu/proj/pgpdump/en/"
  url "https://github.com/kazu-yamamoto/pgpdump/archive/v0.33.tar.gz"
  sha256 "fe580ef43f651da59816c70f38f177ea4fa769d64e3d6883a9d1f661bb0a6952"
  head "https://github.com/kazu-yamamoto/pgpdump.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8141ac85359c7be7ac5ef51075823612582ecd0e02f0048cace4b4bae2217771" => :mojave
    sha256 "2d5ad982f29c20cad30f5a90d4fcd8af3d369432e2c4ab4f35fcfa3b31712a1f" => :high_sierra
    sha256 "9c2ed5f4eb7e0c833a90d53fc8d96d613b781b36c3524959fa102ae62a4d167e" => :sierra
    sha256 "1cfd7cb5b0cdbc7e70031841d7efb1196ddbbd6f11f5af3cce4b38b6f7358ae2" => :el_capitan
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
