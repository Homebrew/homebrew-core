class Diffstat < Formula
  desc "Produce graph of changes introduced by a diff file"
  homepage "https://invisible-island.net/diffstat/"
  url "https://invisible-mirror.net/archives/diffstat/diffstat-1.67.tgz"
  sha256 "760ed0c99c6d643238d41b80e60278cf1683ffb94a283954ac7ef168c852766a"
  license "MIT-CMU"

  livecheck do
    url "https://invisible-mirror.net/archives/diffstat/"
    regex(/href=.*?diffstat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d3103e7984058fc71ab1f3eb09cf3d29f98351f1ea34647afc446bbf78ead8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "747e0b5ddbdcdd9b446bc71a56677e5edd7330216594aba4bae7a1b169b6683f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae91655c0d795f880f9c9c49dcfbedb5ee1fee98b5f90373875eb4e9b3768fda"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfde6a270ac292e75e80e2d699b14218afe2a3badd8e81d0ec69fd049372843f"
    sha256 cellar: :any_skip_relocation, ventura:       "8350b4b38eac630b7013450248e2e86da255cd4f81bd4952066aaec9097a18b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4cb9055a8446d72ceafba4ae145efcba5bffd11d5c17f36cad97a76a1782d65"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"diff.diff").write <<~DIFF
      diff --git a/diffstat.rb b/diffstat.rb
      index 596be42..5ff14c7 100644
      --- a/diffstat.rb
      +++ b/diffstat.rb
      @@ -2,9 +2,8 @@
      -  url 'https://deb.debian.org/debian/pool/main/d/diffstat/diffstat_1.58.orig.tar.gz'
      -  version '1.58'
      -  sha256 'fad5135199c3b9aea132c5d45874248f4ce0ff35f61abb8d03c3b90258713793'
      +  url 'https://deb.debian.org/debian/pool/main/d/diffstat/diffstat_1.61.orig.tar.gz'
      +  sha256 '760ed0c99c6d643238d41b80e60278cf1683ffb94a283954ac7ef168c852766a'
    DIFF
    output = shell_output("#{bin}/diffstat diff.diff")
    assert_match "2 insertions(+), 3 deletions(-)", output
  end
end
