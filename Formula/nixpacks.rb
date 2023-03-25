class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/"
  url "https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "65957aea51201f0b6f74975024e4c6e8f8636ca33073d624960a38688ae92b1c"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25562d9531cc2220923377a36bf82f44baa7a6a48c3fc00c53ec884348a5a3c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04caa39472efb4485925212b65042189b23c349190ca5f61efc82e8d4c7bf980"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95e5c1b022dd0ceb4c383eb071f55816f2d0600eae57885690ceeed45a47c442"
    sha256 cellar: :any_skip_relocation, ventura:        "973e3b83fd564860dc07948d7807d8d91b0a2ff70f29d02745bc3876c8556dff"
    sha256 cellar: :any_skip_relocation, monterey:       "ad7b05596b759b4a9125c53773c4496a7e491b724366f5b94470bdb9d6b09038"
    sha256 cellar: :any_skip_relocation, big_sur:        "d513afd5a9ad1cbc516bc543c5c3a582848308201c0c2c1e03655a5d9c7ca438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48e4219364fd138f3f040381a729d21af615371ba82442db030ca030ecf2f2ba"
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
