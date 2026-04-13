class Pgpdump < Formula
  desc "PGP packet visualizer"
  homepage "https://www.mew.org/~kazu/proj/pgpdump/en/"
  url "https://github.com/kazu-yamamoto/pgpdump/archive/refs/tags/v0.37.tar.gz"
  sha256 "bc3b6b85f3c95c68010883675283c1c905e6c4070ac5609ced1a87c53b3ee814"
  license "BSD-3-Clause"
  head "https://github.com/kazu-yamamoto/pgpdump.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7271c0c87d0ab2641ee5ba2b4a56087dc676c94c74114f35864c2b05bfd5d740"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "538a68ce61a4964200f14a933f9ef1153b3c6aeb7912e9652d5175e993bc5f01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7d16c551bec4f31b919c6c25373d2eb1217e97143c690ed1828be4c5376d186"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bd623ea842793c2e06a30ec74e377ba98b6cc671c1bd3437f124af2a1b5028c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37130fe3de7e8189c3ebdc12b5d8f83a7d91aeb6932183266b7c48ea93244b82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc370e7ed6cd6bf5ea931c21086f4c2c1e493f166f663212682b4d4427d50cb0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
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
