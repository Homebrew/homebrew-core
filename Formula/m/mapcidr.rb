class Mapcidr < Formula
  desc "Subnet/CIDR operation utility"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/mapcidr/archive/refs/tags/v1.1.34.tar.gz"
  sha256 "296950c4123d34554a9f0746f1bef074374b7ff778fa5fbcc92a24fe149fe78d"
  license "MIT"
  head "https://github.com/projectdiscovery/mapcidr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb89cba8eb2951d6031b6596f645ff095a0a45fa32e801eba3428112e9805262"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14c162c1728ed3a4db440a87a7c50a83a56e1850cf3b63ffe6141a13dea3685f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6bdc1c16bde927ed10481ae997d383d1cc8e51ba21c8c8d70f287dc16607939"
    sha256 cellar: :any_skip_relocation, sonoma:         "402aadaa69b3d0d49ea79073f889c83abc4e06ce2168aa9d8970271e3ae14805"
    sha256 cellar: :any_skip_relocation, ventura:        "8e872b8888bcd318860259bd57a024b1fc4f339ecfc226f8f9473b230d040843"
    sha256 cellar: :any_skip_relocation, monterey:       "e8dfa1fb2323413d735e839062901fff2b9ede039ce62c1ce62cf0ac46f58507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59d005c2c7a7f0e9f40d332ab2eca37651bb4480d83baeef707d1c9619d99c62"
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
