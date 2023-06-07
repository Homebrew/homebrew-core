class Disktype < Formula
  desc "Detect content format of a disk or disk image"
  homepage "https://disktype.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/disktype/disktype/9/disktype-9.tar.gz"
  sha256 "b6701254d88412bc5d2db869037745f65f94b900b59184157d072f35832c1111"
  license "MIT"
  head "https://git.code.sf.net/p/disktype/disktype.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/disktype[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6edc8c7808c4d5acbce3df4c4dd0ba4c9dff05831e18eccdeca105a5ebe1c40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "154bd7b1f165caf396b4c1659fb1af90f8a64cfdcdf47a421d4d6ee2af32e555"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4587dd61a91f93d065f3f169b690f8f194d1177c5b3cb7a78c0edec9bc0a23a9"
    sha256 cellar: :any_skip_relocation, ventura:        "12c3b63110fa663a8a7fe20080db82f2968fc0ed6888bb3a53c37a74297f57df"
    sha256 cellar: :any_skip_relocation, monterey:       "edc7efe783d43679fea498893be6c511023d8ccf7d823eaf05ca57cde41202e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "06ea5af49f19f974e3d7f91f9a8e9e178f90b5e8390c59c324179773e17e21ac"
    sha256 cellar: :any_skip_relocation, catalina:       "6821d802c4418c949b8e3394893f03cf6152020881096b304ab0c87313fff2e3"
    sha256 cellar: :any_skip_relocation, mojave:         "7b401cb017bbe0f119b590839941ca7a8d77136483f651504382ed595f4280ec"
    sha256 cellar: :any_skip_relocation, high_sierra:    "b6212feab524e86a8fc1f3c366092af206dee279900ea2753d331b295dd22c14"
    sha256 cellar: :any_skip_relocation, sierra:         "18ed63d389b55d3dabb84e355323f303013acd46a1905c194b470cc74fc95e4f"
    sha256 cellar: :any_skip_relocation, el_capitan:     "c1f45dc2bdcec2e3b56741bf03d673f3a99534f851d1c77de59d6832d0f75236"
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
