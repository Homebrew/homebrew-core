class Cidr < Formula
  desc "CLI to perform various actions on CIDR ranges"
  homepage "https://github.com/bschaatsbergen/cidr"
  url "https://github.com/bschaatsbergen/cidr/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "381b14463e641455dc4ce3a5765bae6eee774b753c1f69e843ba4bce19b932cc"
  license "MIT"
  head "https://github.com/bschaatsbergen/cidr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "50470ddf2ff8362771bf55d413fa036fb789cc6fdc89c440d8fdd0f11557149c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d100fcda482c2e9e1fa84059dbcc6ee3bcb0f6b44534051b2820b3599622de13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4fae10a38bc26f5562624e84c0412226c3eb28cb96e3361750a8fcf0e798c089"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae99142db8cb72c60caf5d4cb52fcf58a301b4c28aa27508e6008191c5a2510b"
    sha256 cellar: :any_skip_relocation, ventura:        "0bb691f4e2379110b08f77b62df92b917deb67410289e95686286264c9979996"
    sha256 cellar: :any_skip_relocation, monterey:       "bd415bc9e3a1d04f40d40d5a4548a1e73ac4664efb0d893c6568bae278d2fef8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1aa1a8b3b7311043bf209e71f24f3a676f53c143a50ea4b35a1327c08b95386c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/bschaatsbergen/cidr/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cidr --version")
    assert_equal "65534\n", shell_output("#{bin}/cidr count 10.0.0.0/16")
    assert_equal "1\n", shell_output("#{bin}/cidr count 10.0.0.0/32")
    assert_equal "false\n", shell_output("#{bin}/cidr overlaps 10.106.147.0/24 10.106.149.0/23")
  end
end
