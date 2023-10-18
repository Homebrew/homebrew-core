class Mapcidr < Formula
  desc "Subnet/CIDR operation utility"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/mapcidr/archive/refs/tags/v1.1.12.tar.gz"
  sha256 "7c6c93ca487efdbb6403ab7738c59b0a80eb86288416a9469a0e9e3b3326ae49"
  license "MIT"
  head "https://github.com/projectdiscovery/mapcidr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2509f8839b957f4c87664404e19948ae8aa5cfeed97105ed73cb748723808b9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94db63ae18100f20e372ca9ebe225cc79ec4a86487f1bd74438231b100c673cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ed12a3e00cefefe2106ede1b2797f5ffb18515f17dd5a9b6b8d6125f2d4b43b"
    sha256 cellar: :any_skip_relocation, sonoma:         "89046937229d09f15051a0b5f24f0c533280b2f7feb313ebbdf5f3d6ddb5c129"
    sha256 cellar: :any_skip_relocation, ventura:        "a00ca2bdb1131083a49ab144047ffc688abb8db798f54d0c4a5e8245ea7a6195"
    sha256 cellar: :any_skip_relocation, monterey:       "92d1b3aba01eae610bb19a2d2b3526cf309cc53ee3b0f0dbc27b17ee864db96c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19d26bee5f7a408ab6cd4dedd4101400f139c7b05600b64e2978531c63542e3e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/mapcidr"
  end

  test do
    expected = "192.168.0.0/18\n192.168.64.0/18\n192.168.128.0/18\n192.168.192.0/18\n"
    output = shell_output("#{bin}/mapcidr -cidr 192.168.1.0/16 -sbh 16384 -silent")
    assert_equal expected, output
  end
end
