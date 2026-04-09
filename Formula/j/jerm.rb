class Jerm < Formula
  desc "Communication terminal through serial and TCP/IP interfaces"
  homepage "https://web.archive.org/web/20160719014241/bsddiary.net/jerm/"
  url "https://web.archive.org/web/20160719014241/bsddiary.net/jerm/jerm-8096.tar.gz"
  mirror "https://dotsrc.dl.osdn.net/osdn/fablib/62057/jerm-8096.tar.gz"
  version "0.8096"
  sha256 "8a63e34a2c6a95a67110a7a39db401f7af75c5c142d86d3ba300a7b19cbcf0e9"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "584ce1292fc18f70a010cd4bc311630e44113232c7ab10b30b24c90e2c967e32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "96b7c79c29b63fe4f2819bb547c97c77d870aedc601d90e5e92a6b6657d89b45"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e46c7e764bb5fe86fb48dda5fe2b9f03624357f726c93399f5752ff5f6ee60b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c94b2dab39c4117d7099e34eb303fb3477247163b37d19b7601348cb7917d315"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3aeeab223b7e4375ecd06ff91d422d7e00981501f09ad448b7c99f74bdc571d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d1ca7129e6eb221c5a83ab2a5f631be2d9acf0a7aa1897fd1f481924373497e"
    sha256 cellar: :any_skip_relocation, ventura:        "d577776b3f4fe4763f65dd44608660703ba446404125d5f645f16c727251898c"
    sha256 cellar: :any_skip_relocation, monterey:       "7d90c12f4c72c6d13fb1f5eac37ddf2c1f92db2781b16c666e84fa90e3a58a7c"
    sha256 cellar: :any_skip_relocation, big_sur:        "15802029e8244b41d39836347f57e0f7020b06a7a8463ffece0b418a28b28050"
    sha256 cellar: :any_skip_relocation, catalina:       "679f37e7f92c4eb64a0c94e11e8fc1bdc1b28f3bb7fbefafc38a955318d2f03d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5179ab5a7d5299398a5c70934bf177a1537dbd4f05db4f37be578978f056e379"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2396a1d6257e20a5115a14f270c4c4039b91a3f9fd86fb8ad8437735bd98869d"
  end

  deprecate! date: "2024-07-03", because: :repo_removed
  disable! date: "2025-07-07", because: :repo_removed

  def install
    system "make", "all"
    bin.install %w[jerm tiocdtr]
    man1.install Dir["*.1"]
  end
end
