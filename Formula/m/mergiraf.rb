class Mergiraf < Formula
  desc "Syntax-aware git merge driver"
  homepage "https://mergiraf.org"
  url "https://codeberg.org/mergiraf/mergiraf/archive/v0.17.0.tar.gz"
  sha256 "88f8fa352835a8c1d5eded304993fdfba7bc515c2e71f8331f1e43c9454cd62c"
  license "GPL-3.0-only"
  head "https://codeberg.org/mergiraf/mergiraf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e9e434de03ec189351c3faf034138ef1554a4d8003adb3ebc75c95a2f5b9af6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "175f5f3d864bc47bbd0ff0809871cd9f53c402fd924a17f5550495711b815fe0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83b2d77af73dce1c80443c7950fa67a9a8bb6b1363b85b6d563870905b825a83"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5f0d160f9cd5d225d007194c6f8ee52200e068e1bc4a1629f639b775e11b1a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0435aca2e9472f993e18f11a83d4ee54dfcb3990acebe64c6ff29a7595f2ced3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e7834e1dc9c88b2e1e9eedb91dc7d67f32937bbb823e99013358978c08850d8"
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
