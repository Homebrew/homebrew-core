class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/"
  url "https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "578854c0296bfebe100f900266c291956eebe478b81ce5b7818ea7f605a8ffd5"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b722dbee62019ffe8137eaa22edabd6461603c4795a7cadda37f4a03d0d6b1c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68f2e87d9ac3fe9c716f749d87ab978ea369d2ee97e5857367c3e5a4a5040bd2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cbd5fb928f92ea798401ec9ef49897779e5ed9a4b1961d371c189fc3d926644"
    sha256 cellar: :any_skip_relocation, ventura:        "3e90a7ccb0c4bdcd0f16b6d43e6ffdda51708aed7d69f1aa2f6ba7091b656300"
    sha256 cellar: :any_skip_relocation, monterey:       "ef2590bfdb4e3bfda468f349e8eafbcb7b5c32e029fb6b53be6112181524d24e"
    sha256 cellar: :any_skip_relocation, big_sur:        "3aedf2582c55331eef935e2b3a0a40de9250a9c4a762e4a71a5b95c4b325233e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fa521383fba8ec4f09006bce3caa66a986fc4ece2c8cbe04ff3740105c1a16b"
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
