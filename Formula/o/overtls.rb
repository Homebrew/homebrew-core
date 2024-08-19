class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.2.33.tar.gz"
  sha256 "5f400fb0d056668a7d763ce7d45348696da5b01737c8313a64d77e88d45388d1"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "abd2ae2b72845185caebae26a331629bebb680b76626fbbb7ba4d2909c1db470"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f7a0f132248f79b2558b6da07e4e8c5204150f8596dc9ee09c49a7293b2e8a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f46410cb7899fb8a5d96fea9d20a57de72f06cd1af5500aefa125b5b571b084"
    sha256 cellar: :any_skip_relocation, sonoma:         "31a570b5be4549f0d234c6d7d4df8edf064e40d15ccdab6aff6012f2c1beedde"
    sha256 cellar: :any_skip_relocation, ventura:        "6b2943c34ba08945be411ee43d02747e95d615cc0cffd6dca14b394ea6835236"
    sha256 cellar: :any_skip_relocation, monterey:       "f432aaadd6996c414e8eb7a42ffbcac2cdbe50505a7b55bb2dc63dfeeae4dd11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5251501b4f283da6ae1a6182f7a5e89a85907c5b80c13de3b101bd65be40126"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/overtls -V")

    output = shell_output(bin/"overtls -r client -c #{pkgshare}/config.json 2>&1", 1)
    assert_match "Error: Io(Kind(TimedOut))", output
  end
end
