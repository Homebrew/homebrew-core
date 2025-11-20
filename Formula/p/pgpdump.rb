class Pgpdump < Formula
  desc "PGP packet visualizer"
  homepage "https://www.mew.org/~kazu/proj/pgpdump/en/"
  url "https://github.com/kazu-yamamoto/pgpdump/archive/refs/tags/v0.36.tar.gz"
  sha256 "9831fb578175f97f77e269326cb06e5367161e9ddbbfb7f753cef12f0f479c1d"
  license "BSD-3-Clause"
  head "https://github.com/kazu-yamamoto/pgpdump.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "85243a86d8e3ea3d785a64a923646171e20ad9be329360f6b93f74608db023b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3e1106f448c38f9e3c36c90d622db3e4e0fba0375346446d8b5f8b50acc8fae9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1486016d74d108d52c41c9b09d8d681bc7a08e553a6e65f1753b37df3ce6e18a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a989f9d5f92668d4d84666bb1cc2654a7bbc4eff4514f184d88f24eaedb074fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52448666ef81ee5ba314eea314299c6785f507adc28924fdfe4812bd3efeccf3"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d251de5de502b17047090b372b041cfa01f36300da79b7cdb31c1a2742d13e8"
    sha256 cellar: :any_skip_relocation, ventura:        "182e8c57659d5aa820da72ba424ffe35387f18982fd203ba19c3eedc15636acf"
    sha256 cellar: :any_skip_relocation, monterey:       "1840aa585133917d6134062341a3f99b6d9f75bae841a5c17f03875f32550860"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0b513cc3a5634c9f81ac831e5fce2db784e947233439706b34a2dc3b44391714"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee47fa9dcc4ffe236943ebbb493b3c6b95237576d3b69e1c847025632f9b4e91"
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
