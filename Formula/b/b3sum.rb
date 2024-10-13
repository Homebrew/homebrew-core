class B3sum < Formula
  desc "Command-line implementation of the BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/refs/tags/1.5.4.tar.gz"
  sha256 "ddd24f26a31d23373e63d9be2e723263ac46c8b6d49902ab08024b573fd2a416"
  license any_of: ["CC0-1.0", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "fe35bfce0671e18a64849c7058afe0954c89af8d455b48ebe7f81fad8ff3163a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c06d5ab0945af5136872f7416e7ca30b81114042121774b88cf9d1b16a4ec083"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd2814bac039ad97a977980a1efac2948c98e68775a60203ed2d0233a212e7dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a52d4b0e231e19b4e0b096b8fb4ecbde3cd01a36feb5ec7e3bffdba9df530c57"
    sha256 cellar: :any_skip_relocation, sonoma:         "41a72f0fc4d7c8cdd9a71e6ea7ed71787fa93be8802e057082d38ec3344af21d"
    sha256 cellar: :any_skip_relocation, ventura:        "58affc8a903569e96fd41df552cba86cb3a8f3f640dbf300cfafaff19afc0133"
    sha256 cellar: :any_skip_relocation, monterey:       "a1b3a4bc1b1e1b587c03b140359b531c1d80ed7044991aba48d561d8148cf364"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a9ea3f9205c87cdf3807f1604a1af25c25070653061db2d3167e4abe714a2d7"
  end

  depends_on "rust" => :build

  def install
    cd "b3sum" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"test.txt").write <<~EOS
      content
    EOS

    output = shell_output("#{bin}/b3sum test.txt")
    assert_equal "df0c40684c6bda3958244ee330300fdcbc5a37fb7ae06fe886b786bc474be87e  test.txt", output.strip
  end
end
