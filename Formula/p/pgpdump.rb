class Pgpdump < Formula
  desc "PGP packet visualizer"
  homepage "https://www.mew.org/~kazu/proj/pgpdump/en/"
  url "https://github.com/kazu-yamamoto/pgpdump/archive/refs/tags/v0.38.tar.gz"
  sha256 "6e994c2ee7479ea4f4492d5d94d7177ac493fdb1b1bcf698aa90ae26495fd95b"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/kazu-yamamoto/pgpdump.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "461263e1f721e46bb5673ead579b1fabb6c5e9c462a3003f4e14ee879e10fa52"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8fc69f799ea95e3e89ccb78bc8661153a67343db86b19d92d822e6428b71e7d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bc5590a7b082b8c32cd7fb39b62906eb31d08b742b8e4faa095a75b2c81d46f8"
    sha256 cellar: :any,                 arm64_linux:       "0a0d71dde70381e31b523b558e00d30aa46f2da428fd6bb87db1cd1059073d31"
    sha256 cellar: :any,                 x86_64_linux:      "186cbee04dff0d6c779c20c0e4d5bdc76f486149124aaa02a0adbc5f45bcd4ba"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

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
