class Pgpdump < Formula
  desc "PGP packet visualizer"
  homepage "https://www.mew.org/~kazu/proj/pgpdump/en/"
  url "https://github.com/kazu-yamamoto/pgpdump/archive/v0.33.tar.gz"
  sha256 "fe580ef43f651da59816c70f38f177ea4fa769d64e3d6883a9d1f661bb0a6952"
  license "BSD-3-Clause"
  head "https://github.com/kazu-yamamoto/pgpdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d47c8e594e8da1e715299908ed6e4de72548176131f396613764a9e39d0f1a86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2be885245f927b5cc3203bff8af2f063d60853d2c7627100ef46f8cd4eb730d"
    sha256 cellar: :any_skip_relocation, monterey:       "41fd68b09f849b1ddc1697f352282b897bf359bc92ca3bb50ae05e9ee0f765e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c87222c16b88f4f1a34504d503eb7bebd6559da8029cd4cd374d27bb694cbc88"
    sha256 cellar: :any_skip_relocation, catalina:       "60bbe481621cc653edc834b9d54b910deb3c1634cc7155dd1e9aca9e3f207ca4"
    sha256 cellar: :any_skip_relocation, mojave:         "8141ac85359c7be7ac5ef51075823612582ecd0e02f0048cace4b4bae2217771"
    sha256 cellar: :any_skip_relocation, high_sierra:    "2d5ad982f29c20cad30f5a90d4fcd8af3d369432e2c4ab4f35fcfa3b31712a1f"
    sha256 cellar: :any_skip_relocation, sierra:         "9c2ed5f4eb7e0c833a90d53fc8d96d613b781b36c3524959fa102ae62a4d167e"
    sha256 cellar: :any_skip_relocation, el_capitan:     "1cfd7cb5b0cdbc7e70031841d7efb1196ddbbd6f11f5af3cce4b38b6f7358ae2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0089ba0d93112995da62e95bc7f3e9483e12394ecfef3a84c5e3181843743cd8"
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
