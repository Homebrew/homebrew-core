class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/"
  url "https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "0bc6aefd11ef947b8324051cbb08933d001e58adfb853de05437ce25d811b6c4"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f7894ad20e2dc8d35e8cdce6916370f33996baa94a47f690700e00e9fdfbb94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db3fb9596c109979bd15fffcf2499aeada297db08a7509d3dadb9276ed0e3849"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e321578411af805113ac1a38abaf1a415579b99e9a65ff39204a9f1c733941a4"
    sha256 cellar: :any_skip_relocation, ventura:        "e0220e4a89563e89ee9a0199f5e26487ad73753a3ee877912f35b7ad3e08683d"
    sha256 cellar: :any_skip_relocation, monterey:       "cc5e61155974c3850aa85dfe3cc2ba73c9e828f95eef2a8907212b6a345c1bc1"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a9582ead8bc3d8a7610d6e99194e48c2a2d206f475c56c19ec423e3bbd261da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8b2ba777688572a5cb730fb05332841fba789d4010dfdec1b280264ce79d64a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/nixpacks build #{testpath} --name test", 1)
    assert_match "Nixpacks was unable to generate a build plan for this app", output

    assert_equal "nixpacks #{version}", shell_output("#{bin}/nixpacks -V").chomp
  end
end
