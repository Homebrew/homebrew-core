class Ducker < Formula
  desc "Slightly quackers Docker TUI based on k9s"
  homepage "https://github.com/robertpsoane/ducker"
  url "https://github.com/robertpsoane/ducker/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "79f403a29aedfca1e043dd9aa54363e1c142ba8c46b09623e7ec70f18a6d3595"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ea74e20d441da32d9ce6450b9dbabc11cf145c6358345594762f89e7365d32e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bed8487fea22c337905f9a3aad37425b2c43952ad88863632acf001ea58dfef1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2f3e9c156955e19f1893858d5a79dc995f9761bb373acd2ce1b82964a8e3556"
    sha256 cellar: :any_skip_relocation, sonoma:        "db041e08f90c3aa4f4453324f4ae07c7da190f7a3cbffebca196e52c6c249210"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e52a5efa06736192bd41bf24f24ad292c1938aed167aebfb9ac2441d4ff8a3a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d3896096ac4950155e48296808309776c4795a82e92c15419be99f475d2f6b5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"ducker", "--export-default-config"
    assert_match "prompt", (testpath/".config/ducker/config.yaml").read

    assert_match "ducker #{version}", shell_output("#{bin}/ducker --version")
  end
end
