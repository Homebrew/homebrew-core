class Pgpdump < Formula
  desc "PGP packet visualizer"
  homepage "http://www.mew.org/~kazu/proj/pgpdump/en/"
  url "https://github.com/kazu-yamamoto/pgpdump/archive/v0.31.tar.gz"
  sha256 "7abf04a530c902cfb1f1a81c6b5fb88bd2c12b5f3c37dceb1245bfe28f2a7c0b"
  head "https://github.com/kazu-yamamoto/pgpdump.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8925b858ba5c77df3c982d318a047936c211578b05c9c6140f11f869f4ef1c3f" => :sierra
    sha256 "78e39ebbde35347ccdf9f552cba605593b4a76511ef25dc147fdf63f57ff96b6" => :el_capitan
    sha256 "e526cce3b8ac5cc687f5a87feb2f3d8828255f4e63cf8f225e56439df549a25e" => :yosemite
    sha256 "27a463ac9a015d1484508f2d625d1e5f4349e79b8331f8e9f78c647f4964da9e" => :mavericks
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
    assert_match("Key ID - 0x6D2EC41AE0982209", output)
  end
end
