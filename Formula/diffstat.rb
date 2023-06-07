class Diffstat < Formula
  desc "Produce graph of changes introduced by a diff file"
  homepage "https://invisible-island.net/diffstat/"
  url "https://invisible-mirror.net/archives/diffstat/diffstat-1.65.tgz"
  sha256 "8cf27424926debcd85921755c3915559288244bd103f62d740dc6b83b557a28a"
  license "MIT-CMU"

  livecheck do
    url "https://invisible-mirror.net/archives/diffstat/"
    regex(/href=.*?diffstat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8715540f85a0024e3cb2d5f8c6025a0955fab8a2be96689261c39340be9b1fac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ced0dd5af5160876b20660affb0a46d147b03f52ef7fa555eb8ec4b101cd411"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74504908013dcc1821dbebb01b3e9d16db70c1ea163c3d432de5b0b2080c40b4"
    sha256 cellar: :any_skip_relocation, ventura:        "6e815d61267bf0da0827fef4c26e09e03371c75bb7e0029f0d9ce9ad7bb49987"
    sha256 cellar: :any_skip_relocation, monterey:       "f32bb0644feec82662e80e5c6f691087c3903612589acc86f16042ebf6369368"
    sha256 cellar: :any_skip_relocation, big_sur:        "097e47798dd87dd2d0f1dff6f859fa6626f9dc5cb21db0f4b39e95063b785824"
    sha256 cellar: :any_skip_relocation, catalina:       "ca4b882879eb118c796948fb3e144b6caa54e709697f8cd44226e4f76c904531"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cff127c5cd8976be4e9f0d0d2201c31918822060f4b8a1fa3c632574ddd2e1d"
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
      +  sha256 '8cf27424926debcd85921755c3915559288244bd103f62d740dc6b83b557a28a'
    EOS
    output = shell_output("#{bin}/diffstat diff.diff")
    assert_match "2 insertions(+), 3 deletions(-)", output
  end
end
