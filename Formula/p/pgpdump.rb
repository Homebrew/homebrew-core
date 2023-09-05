class Pgpdump < Formula
  desc "PGP packet visualizer"
  homepage "https://www.mew.org/~kazu/proj/pgpdump/en/"
  url "https://github.com/kazu-yamamoto/pgpdump/archive/v0.35.tar.gz"
  sha256 "50b817d0ceaee41597b51e237e318803bf561ab6cf2dc1b49f68e85635fc8b0f"
  license "BSD-3-Clause"
  head "https://github.com/kazu-yamamoto/pgpdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0e14d1d33d4d473b5290f7043f0d7c08770cc2866cf90f30e78ed2666ad8399"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac46048c8942181a690342b419170333bf927cab9c2d0e44438b958c5b0e11b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c11019a404c8ae3a4f7519a243fbdaa878052ac2512e583ce14c60fa57dedec9"
    sha256 cellar: :any_skip_relocation, ventura:        "e5f32ed8b98d9142658696e3708ad6a276fdebd83022a88211399ac2fff81ee2"
    sha256 cellar: :any_skip_relocation, monterey:       "62f3bdf6d9a51b7f8784af38704430b845086339f170b926edc323852f161728"
    sha256 cellar: :any_skip_relocation, big_sur:        "1efb877cc6591952d096279502e7fe4a64bd1d849e5d3c4cbededc1d2a823839"
    sha256 cellar: :any_skip_relocation, catalina:       "dab47ba0a8b1e740427b3757eb1f0e64ab246266f8e5983cca29796ba53b9ed4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1898d68705749cf00190abbbb994003aa3def71515468331a074aabadf7ffd6"
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
