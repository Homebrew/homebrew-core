class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v2.0.0",
      revision: "625e6e066c6b2397b1382d6de6773af7df0fb276"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "970210ba35275ac60ed99e18084e71319b8120926f8acfdf143a850e4605e3df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2b7ad10c6ebe38772ed831075667da0223de4cce6875c0f9bbe2d985fdb9d2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b46efd17141c0cdf6c6f02cc4ba22ce766ed0f10afd65f40cd23f1406aee2abf"
    sha256 cellar: :any_skip_relocation, sonoma:         "705af754e5fb444be4c83c930baf39cb3d6b110d3f29cf8c05bd856d56b09551"
    sha256 cellar: :any_skip_relocation, ventura:        "1fe1ea6ff2116d989353ab6f14d627760fa0c94ab36fd08604bede8fde81d27f"
    sha256 cellar: :any_skip_relocation, monterey:       "d48fc0d0d0c99a90796be44906b63b060d62f474218e169ff9478e79356a311a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e395f88db77a50ae8563960ee4680a186278bd405182a6689ad7f552488cc2e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "clarinet-install", "--root", prefix.to_s
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
