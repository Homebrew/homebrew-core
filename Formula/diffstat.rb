class Diffstat < Formula
  desc "Produce graph of changes introduced by a diff file"
  homepage "https://invisible-island.net/diffstat/"
  url "https://invisible-mirror.net/archives/diffstat/diffstat-1.64.tgz"
  sha256 "b8aee38d9d2e1d05926e6b55810a9d2c2dd407f24d6a267387563a4436e3f7fc"
  license "MIT-CMU"

  livecheck do
    url "https://invisible-mirror.net/archives/diffstat/"
    regex(/href=.*?diffstat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8ff4098fc0eba445fdefad3b4fcbb518f029a8284534f39acd40fa99cd7e356"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ca28eac2743d6dea9f9128b51ac0107d627f64cc421033538468930f291f3fc"
    sha256 cellar: :any_skip_relocation, monterey:       "7d83c828daf8ff308abd1295ac28762ac85e207d726ea6075505cec200153a6c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6deaecbddb668e6a0beeadf19f80bede5756279949b872bd15ec2bdae432ed77"
    sha256 cellar: :any_skip_relocation, catalina:       "9d8296df829318dce8e829eef894867a74d3f18d438de98309b0c3fe02e065cf"
    sha256 cellar: :any_skip_relocation, mojave:         "5b035ed0d84aa480965b56e0a8db59ebbb947dee3379297a3f05f88dcd610d81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36edff1128de8ec03a0d8f3b2e0f167939543a7cc374c9a30d45271c457fe544"
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
      +  sha256 'b8aee38d9d2e1d05926e6b55810a9d2c2dd407f24d6a267387563a4436e3f7fc'
    EOS
    output = shell_output("#{bin}/diffstat diff.diff")
    assert_match "2 insertions(+), 3 deletions(-)", output
  end
end
