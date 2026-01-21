class Disktype < Formula
  desc "Detect content format of a disk or disk image"
  homepage "https://disktype.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/disktype/disktype/9/disktype-9.tar.gz"
  sha256 "b6701254d88412bc5d2db869037745f65f94b900b59184157d072f35832c1111"
  license "MIT"
  head "https://git.code.sf.net/p/disktype/disktype.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/disktype[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "42c78cc38ea028f25b5c2122e72e66d49803b717c8994a45db84fda5b192f492"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "cc0c898196ec806c92c56cda1d1edce496eb6dea79d614ab746021f2e315ec4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "867972214905edb51443e921e727b9916eb9ff528ee18aac77e205d43a80ed9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6edc8c7808c4d5acbce3df4c4dd0ba4c9dff05831e18eccdeca105a5ebe1c40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "154bd7b1f165caf396b4c1659fb1af90f8a64cfdcdf47a421d4d6ee2af32e555"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4587dd61a91f93d065f3f169b690f8f194d1177c5b3cb7a78c0edec9bc0a23a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "f526684921eb7bab672a8df27f08c0431fbb203fa026e88c7a1970ad207aa594"
    sha256 cellar: :any_skip_relocation, ventura:        "12c3b63110fa663a8a7fe20080db82f2968fc0ed6888bb3a53c37a74297f57df"
    sha256 cellar: :any_skip_relocation, monterey:       "edc7efe783d43679fea498893be6c511023d8ccf7d823eaf05ca57cde41202e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "06ea5af49f19f974e3d7f91f9a8e9e178f90b5e8390c59c324179773e17e21ac"
    sha256 cellar: :any_skip_relocation, catalina:       "6821d802c4418c949b8e3394893f03cf6152020881096b304ab0c87313fff2e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7e5b37f738b0519b463163cdfcea5a7ee21c829e409f613be7f7cbc8f9120afa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b0dcc67cc8fee509011e50ff1299b4205b424f83ee9aedff5d97fb2e603b6bc"
  end

  def install
    system "make"
    bin.install "disktype"
    man1.install "disktype.1"
  end

  test do
    path = testpath/"foo"
    path.write "1234"

    output = shell_output("#{bin}/disktype #{path}")
    assert_match "Regular file, size 4 bytes", output
  end
end
