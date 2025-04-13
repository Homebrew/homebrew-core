class Mergiraf < Formula
  desc "Syntax-aware git merge driver"
  homepage "https://mergiraf.org"
  url "https://codeberg.org/mergiraf/mergiraf/archive/v0.6.0.tar.gz"
  sha256 "548b0ae3d811d6410beae9e7294867c7e6d791cf9f68ddda5c24e287f7978030"
  license "GPL-3.0-only"
  head "https://codeberg.org/mergiraf/mergiraf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "311d1e9469153c5663c6ec315177f4dc43715ddaf9501bbec30df9ba594dad5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf9cb08cd2fb85ac1944890b46fbe9ff085f83e47909c9f721531b1de829f9f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c979ce12320277b95e0c7db773aab4ba0406d89177d04b76c49a1a8bab8c4d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a0a9e3907e9ff509763df41fd67e6cac460ef3ce0ec3469edbbf216445729cd"
    sha256 cellar: :any_skip_relocation, ventura:       "2c21bd679f4566d2c7a59a8133938adbce72e89c4f9009aaee0c5d80efa8c343"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e52cd9dd0fb16600aceeac242cd1e6e9b0747c1edf577b8cd21e0c7dd086a28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3d7ae51f6afa19f520d2cf863e35f1956861a4c4c823ade2e750ad1734b199a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mergiraf -V")

    assert_match "YAML (*.yml, *.yaml)", shell_output("#{bin}/mergiraf languages")
  end
end
