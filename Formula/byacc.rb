class Byacc < Formula
  desc "(Arguably) the best yacc variant"
  homepage "https://invisible-island.net/byacc/"
  url "https://invisible-mirror.net/archives/byacc/byacc-20221106.tgz"
  sha256 "a899be227bbcac9cf7700f7dbb5a8494688f1f9f0617b510762daeace47b9d12"
  license :public_domain

  livecheck do
    url "https://invisible-mirror.net/archives/byacc/"
    regex(/href=.*?byacc[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc363339a3d86acfe479196709c41c8c948ff55972f02ec300f8f6459cf2ade3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "084b7eb8c17ebab029dd9dcf7119380100279cff9cb5d230ba53282cec25aaa4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c92d4f7a3ce1de2ee2a3688b32bdb4eff20d5d3fdc10f9214aab5ed1e7c7a08"
    sha256 cellar: :any_skip_relocation, ventura:        "09da49f6675999f0a02086c53a1acc43978dce52af799624d09c5f8968477759"
    sha256 cellar: :any_skip_relocation, monterey:       "b89596f1480a2b98169024580f98b909ced06bdb1089a84bf8b1d3534308543c"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b7542712ab9dc0ceefc523813616fac858e425953f376cabdffe4c96867df14"
    sha256 cellar: :any_skip_relocation, catalina:       "f39472e7cd5de414a689cb8259a33dd6135eb562aa28863b082d70c6b8fce98a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98bdf16d7b6ed50049ea611d84fbabd676f996dbe83fc44929e89ca2f8e11d1e"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--program-prefix=b", "--prefix=#{prefix}", "--man=#{man}"
    system "make", "install"
  end

  test do
    system bin/"byacc", "-V"
  end
end
