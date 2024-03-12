class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.2.12.tar.gz"
  sha256 "17b99177a45270d24bdb81115e6e4efe2f37f8d206d969690a16a714c6043371"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7220068f1ec687594c69858b66f85cace49d19fcfad4b7b0533358e6ceef6a8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f03c4a9b58300211e6d03af385638b1ce249c736f22dd27dc93f026c575659e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "320d2095ae923d79ee3b399c93eab2a212a39dd98258de39035d7bedd50719c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a111ad8dcdb59203c16beea0bb6c5b660bcd74611fd5410a3c1d77c48ce1793"
    sha256 cellar: :any_skip_relocation, ventura:        "93b0fed21510f66d0c6f210aaf2a37327856c6fc3290c67a0324e0dc6812f58a"
    sha256 cellar: :any_skip_relocation, monterey:       "eabfe4b5b9ff47d86c80b22d7ed6b57e3fc9b00c2f0cbce305085737ed9c3de6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7a79ed95205d687621f7ab576215e16a1f2aff77aaf08411ca4bf44460e6323"
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
