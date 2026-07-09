class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.3.10.tar.gz"
  sha256 "da83e27ff9196d1b1055db814f6b86511427ec935c64a9c2862642bfc1737fc8"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19973cad3219f12aa7d184b854eb141dfc57dd29b5529b50c9147b96e4ec5603"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07d2326b203875add91db6e5d261b2a080e33b790810df899ab60beee53a33bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d713106267f9a2c299c8b2cfcee4b913d9bbeebd6b67ec21c96cdd7733c6a86"
    sha256 cellar: :any_skip_relocation, sonoma:        "870fd18d5f528442f3a26ee09ff5254f644a709c5f834e4b6d4627780e878a0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f110f85db97164cd3a028cab525eafed6516634cd4266406d7ac6abf32250cd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e2874ba0e263e8bf4c5e8bc191988a254499244ddad2c1c6c93b464b7db4ff8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/overtls-bin -V")

    output = shell_output("#{bin}/overtls-bin -r client -c #{pkgshare}/config.json 2>&1", 1)
    assert_match "Error: Io(Kind(TimedOut))", output
  end
end
