class Mapcidr < Formula
  desc "Subnet/CIDR operation utility"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/mapcidr/archive/v0.0.8.tar.gz"
  sha256 "8ff4b6ba994f8346197e5266b3939e469dec541d65701bc71134c9081e01e3ee"
  license "MIT"
  head "https://github.com/projectdiscovery/mapcidr.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92ecb467386d10bfab30928188f047eff374ce8f9866ae10cb302e07966be7fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee9e513d9c3207c4ea60e968b24d681e8aaaeb889007007815cfd7dd23b36f37"
    sha256 cellar: :any_skip_relocation, monterey:       "538c36fd427c21cf099e3493426c20054599d4cf0404ac131c85f71b7a163e0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4dbc663d7818217dd387c99c08a8ddc9e596202360d48a69ab2d28edc2f5d46"
    sha256 cellar: :any_skip_relocation, catalina:       "6108174a8882be51d7630f7147adbc078270fc6b5e304271a0370e9555bf44a4"
    sha256 cellar: :any_skip_relocation, mojave:         "b8c7fe7d85135eb8a9d366b1eb95ebf708dd0b21af32f8193934c8f70dd87aa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b19f4cc9371f930349a0f8567a48745c722e2f49b222cfb0101d4a22413b8b05"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/mapcidr"
  end

  test do
    expected = "192.168.0.0/18\n192.168.64.0/18\n192.168.128.0/18\n192.168.192.0/18\n"
    output = shell_output("#{bin}/mapcidr -cidr 192.168.1.0/16 -sbh 16384 -silent")
    assert_equal expected, output
  end
end
