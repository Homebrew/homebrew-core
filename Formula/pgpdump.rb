class Pgpdump < Formula
  desc "PGP packet visualizer"
  homepage "http://www.mew.org/~kazu/proj/pgpdump/en/"
  url "https://github.com/kazu-yamamoto/pgpdump/archive/v0.30.tar.gz"
  sha256 "ef985afa0ae031f3f0319893fadef5b9100de569113ca898d94175b876ddc062"
  head "https://github.com/kazu-yamamoto/pgpdump.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4ec44100285d60658fbef0693b6ba0b2eba90f0fa4c568fba6cbd9d6aec98d3" => :el_capitan
    sha256 "ebc2b805a11e51d13107906b23542556a879642b2a3537fbfdcee31541bd8e7f" => :yosemite
    sha256 "70dde593e7cbde67456e0763b1735af5ef5815e649e4178396d34c6fa7d1a51f" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"sig.pgp").write <<-EOS.undent
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
    assert_match(/Key ID - 0x6D2EC41AE0982209/, output)
  end
end
