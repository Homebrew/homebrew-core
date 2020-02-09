class Diffstat < Formula
  desc "Produce graph of changes introduced by a diff file"
  homepage "https://invisible-island.net/diffstat/"
  url "https://invisible-mirror.net/archives/diffstat/diffstat-1.63.tgz"
  sha256 "7eddd53401b99b90bac3f7ebf23dd583d7d99c6106e67a4f1161b7a20110dc6f"

  bottle do
    cellar :any_skip_relocation
    sha256 "056ed50b34a51b0f86dd9aad74785dc956e204621faa7c0ee4535e4bb54dfdfb" => :catalina
    sha256 "ccdff1c449f1d218ae636de168f9f36fdc1fd8aee3dd71c83ad4d562c7cd4567" => :mojave
    sha256 "aa3691a218fb3b34065729e648dbf4339150de2247f48c458832fba6221ca509" => :high_sierra
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
      +  sha256 '7eddd53401b99b90bac3f7ebf23dd583d7d99c6106e67a4f1161b7a20110dc6f'
    EOS
    output = shell_output("#{bin}/diffstat diff.diff")
    assert_match "2 insertions(+), 3 deletions(-)", output
  end
end
