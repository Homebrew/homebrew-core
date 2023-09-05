class Dynein < Formula
  desc "DynamoDB CLI"
  homepage "https://github.com/awslabs/dynein"
  url "https://github.com/awslabs/dynein/archive/v0.2.1.tar.gz"
  sha256 "1946d521b74da303bafd19a0a36fd7510a9f8c9fc5cf64d2e6742b4b0b2c9389"
  license "Apache-2.0"
  head "https://github.com/awslabs/dynein.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "635583bc18c063999d9135bb322742a17caf167afa6752de58ca871c71894a54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db55aa07dfe414452a0d7137077b8baefe3881ed327623f881f38941cdcfe284"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "739c8a91f706fe1738bd9ba41dac317f0db5728ab17dfe5d7526a3894f6d412c"
    sha256 cellar: :any_skip_relocation, ventura:        "b743e8a94a3d1080bb527fb643f88877a395a71753156fcf7ccc199ec17a58df"
    sha256 cellar: :any_skip_relocation, monterey:       "da3f54319ce86e2bdd1dc9896612a1e6180752f967793a1536e53d3525851f4f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9a51b02ae52fae35a02d8d433a7edaa926215751ddcc0d66986c44ae001aef7"
    sha256 cellar: :any_skip_relocation, catalina:       "f4279bdb47125daff9c6409243f14aba664e18b3a691476fb2372b63c5ed6ea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "075dad3a402d915e8645bd192254f0bbcd68f419e1cd94b936223f2bf319cd78"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3" # need to build `openssl-sys`
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "To find all tables in all regions", shell_output("#{bin}/dy desc 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/dy --version")
  end
end
