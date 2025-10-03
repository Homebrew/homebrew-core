class Diffstat < Formula
  desc "Produce graph of changes introduced by a diff file"
  homepage "https://invisible-island.net/diffstat/"
  url "https://invisible-mirror.net/archives/diffstat/diffstat-1.68.tgz"
  sha256 "89f9294a8ac74fcef6f1b9ac408f43ebedf8d208e3efe0b99b4acc16dc6582c7"
  license "MIT-CMU"

  livecheck do
    url "https://invisible-mirror.net/archives/diffstat/"
    regex(/href=.*?diffstat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aabff535f1643aa62da222acc50f888468d1447a681fd772248776edcdb86b89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78c1cc462b3452c45dfc0a2ee6d512c399a11da0b6e303791ec0c565abf2eb45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8091ee39103e241afc375850844ef3d69dd366ff80b8e1b4946690f6b8be995"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ff5cf1a420613275a0ddbbbeb9037a4a3751cc2374f72d8f77b769534a8aafd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "7dd431cf2efacf1ec9b3f171413962f0cabe1cac57a5c0dc838740b19df9181f"
    sha256 cellar: :any_skip_relocation, ventura:       "c693917f62ffb2ab2dd3b8fbee4c59d8acf0e1851777d42462432e8086c75139"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d852a70b43e45bc2b4c7e6a175be6a363d34c13ae9bdb7d62f7bc7360cfcb24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbb2dfa4d3d9dfa85a897e3514edfd699c972200a758a998458569a7e369cac8"
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
      +  sha256 '89f9294a8ac74fcef6f1b9ac408f43ebedf8d208e3efe0b99b4acc16dc6582c7'
    DIFF
    output = shell_output("#{bin}/diffstat diff.diff")
    assert_match "2 insertions(+), 3 deletions(-)", output
  end
end
