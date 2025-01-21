class Hostdb < Formula
  desc "Generate DNS zones and DHCP configuration from hostlist.txt"
  homepage "https://code.google.com/archive/p/hostdb/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/hostdb/hostdb-1.004.tgz"
  sha256 "beea7cfcdc384eb40d0bc8b3ad2eb094ee81ca75e8eef7c07ea4a47e9f0da350"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "09b528afa8eb8c14becf6bc4240d82b1d40320be2e4a5718af35769e0ba663db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "507656584e0ec815556008dea547944116e8e6c99a3646c3b7ae31b489e337b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1c397eae6bba51e1082904159e462f7cede76d7c3d1def04a0cfbc65cec17d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1c397eae6bba51e1082904159e462f7cede76d7c3d1def04a0cfbc65cec17d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1c397eae6bba51e1082904159e462f7cede76d7c3d1def04a0cfbc65cec17d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "e18f13b9c70d5496eb9ca5066bc2876affd943b2489b99d38e0d2238b70eadc6"
    sha256 cellar: :any_skip_relocation, ventura:        "15df2ae20a92ce1921922de57e085664cc31557f11fcee4dc4a214c7f4c949d9"
    sha256 cellar: :any_skip_relocation, monterey:       "15df2ae20a92ce1921922de57e085664cc31557f11fcee4dc4a214c7f4c949d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "15df2ae20a92ce1921922de57e085664cc31557f11fcee4dc4a214c7f4c949d9"
    sha256 cellar: :any_skip_relocation, catalina:       "15df2ae20a92ce1921922de57e085664cc31557f11fcee4dc4a214c7f4c949d9"
    sha256 cellar: :any_skip_relocation, mojave:         "15df2ae20a92ce1921922de57e085664cc31557f11fcee4dc4a214c7f4c949d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1c397eae6bba51e1082904159e462f7cede76d7c3d1def04a0cfbc65cec17d5"
  end

  def install
    bin.install Dir["bin/*"]
    doc.install Dir["docs/*"]
    pkgshare.install "examples"
  end

  test do
    system("#{bin}/mkzones -z #{pkgshare}/examples/example1/zoneconf.txt < #{pkgshare}/examples/example1/hostdb.txt")
    expected = /^4 \s+ IN \s+ PTR \s+ vector\.example\.com\.$/x
    assert_match(expected, (testpath/"INTERNAL.179.32.64.in-addr.arpa").read)
  end
end
