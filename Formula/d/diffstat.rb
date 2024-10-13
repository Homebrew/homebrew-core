class Diffstat < Formula
  desc "Produce graph of changes introduced by a diff file"
  homepage "https://invisible-island.net/diffstat/"
  url "https://invisible-mirror.net/archives/diffstat/diffstat-1.66.tgz"
  sha256 "f54531bbe32e8e0fa461f018b41e3af516b632080172f361f05e50367ecbb69e"
  license "MIT-CMU"

  livecheck do
    url "https://invisible-mirror.net/archives/diffstat/"
    regex(/href=.*?diffstat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "caedfd307fc53d50c567591390518ee09bfa2d9873f900ff1a9e42b04e9e06f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f9aaf7b60edf88e16525c6d99e1a21a4ee8d3465fd78a42d0288a898ea81a63b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78b7653dc513c433782388d45a7546b149fbcb59b420266df11fc69a639fad45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cbf2a9d950dff62485d341b7f4420ce0d038361e6cdf5a938aad1e09e941b8a"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb5fc38cdb513b49ba03775c081a113cce068a004ff9650eba6e57154fa01a45"
    sha256 cellar: :any_skip_relocation, ventura:        "b91a228be3c16c85c56b031d3f16734b1898a3c60e90b5e2591a16e70434be26"
    sha256 cellar: :any_skip_relocation, monterey:       "df0e83b3ae44e59e511e0975fae4e626945279472e80e61a5bcfad22e5e9b6b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c75eccfa46584a8d3bdfb7b2271b2acaea7a6ada93f0de3b5163f01a276af90b"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"diff.diff").write <<~EOS
      diff --git a/diffstat.rb b/diffstat.rb
      index 596be42..5ff14c7 100644
      --- a/diffstat.rb
      +++ b/diffstat.rb
      @@ -2,9 +2,8 @@
      -  url 'https://deb.debian.org/debian/pool/main/d/diffstat/diffstat_1.58.orig.tar.gz'
      -  version '1.58'
      -  sha256 'fad5135199c3b9aea132c5d45874248f4ce0ff35f61abb8d03c3b90258713793'
      +  url 'https://deb.debian.org/debian/pool/main/d/diffstat/diffstat_1.61.orig.tar.gz'
      +  sha256 'f54531bbe32e8e0fa461f018b41e3af516b632080172f361f05e50367ecbb69e'
    EOS
    output = shell_output("#{bin}/diffstat diff.diff")
    assert_match "2 insertions(+), 3 deletions(-)", output
  end
end
