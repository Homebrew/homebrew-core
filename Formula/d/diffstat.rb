class Diffstat < Formula
  desc "Produce graph of changes introduced by a diff file"
  homepage "https://invisible-island.net/diffstat/"
  url "https://invisible-mirror.net/archives/diffstat/diffstat-1.69.tgz"
  sha256 "bb02464072f769dd9832fd999526734c90eb4d66fb56d5351540a750c88a77f6"
  license "MIT-CMU"

  livecheck do
    url "https://invisible-mirror.net/archives/diffstat/"
    regex(/href=.*?diffstat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17326937151e5a26ce3d23cc4d0fcd180a5e76b097dc77c877ea326ef5ac2d16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0052fe73ac867e0e81faf6c93e30acf3e2bb5fe54ad6f37218619fe9883bcac6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8e5b155acdba8f38f3ec50d9d2c39330c20f52b48ae54e99b52ddf19cb067e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d270a8bab983ec01d0130412f39b9a40a6d18a55e5fed703c8561501c7df078"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c7baa62a2b3c178c170f9681a8d48e50f345ce8ead5765024b6da291b0005d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87b0292cacd262fa0c5d9d55394c97665322d44c0e01227cc9215a924e6ac868"
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
      +  sha256 'bb02464072f769dd9832fd999526734c90eb4d66fb56d5351540a750c88a77f6'
    DIFF
    output = shell_output("#{bin}/diffstat diff.diff")
    assert_match "2 insertions(+), 3 deletions(-)", output
  end
end
