class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.2.17.tar.gz"
  sha256 "dc6dc6930f7762b71813fdde9c806dba91e8c717ff767cce1283bdbcc092aaaf"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f75b5903a7bdd8e6db079c29c0322abfb21ae1c2917e7cb23d2e2a83b394e5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fddd6f854dcb0e3a65e4027a8997310ce0e4d222138ac08aea4dc1a7f6e18879"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72fbe916959f730d5a135d53f7574968db63391e28a1d863a8d4bb455daa7ba0"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d1ef34159ef50adc13bf90cbdc947f15aebe9b234a13a7f4f539c3ebd23b3fa"
    sha256 cellar: :any_skip_relocation, ventura:        "e756f51771edad573e5e4f2e45cf8c750f5d2ad88a71526495ecf2cc72fbc27f"
    sha256 cellar: :any_skip_relocation, monterey:       "094712c7ce59b9a7a74829b24569db9cf65e3396ca206eec9ea874a6b28139e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68ff68208c35a35f0be5973546c57c0c2e12a30d3d43e3bedffd38a775c75078"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/overtls -V")

    output = shell_output(bin/"overtls -r client -c #{pkgshare}/config.json 2>&1", 1)
    assert_match "kind: TimedOut, message: \"connection timed out\"", output
  end
end
