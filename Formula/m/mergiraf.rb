class Mergiraf < Formula
  desc "Syntax-aware git merge driver"
  homepage "https://mergiraf.org"
  url "https://codeberg.org/mergiraf/mergiraf/archive/v0.14.0.tar.gz"
  sha256 "61738fea60d15ffb223d4af2e52fd02b0abddbbd0d9f58f7a33acd49fe4d4f9b"
  license "GPL-3.0-only"
  head "https://codeberg.org/mergiraf/mergiraf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a68c0a4d49e64b0402c57905518a207770d31d45741213c9a70c3cd11b9518c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2e6a8146aa55f01db0f29a1e24dcaa9f7aa7f824e2d1d65e79987eca6f86bee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f62b770c90353c325801f0554f6f34af4bf521bdc7fecd0a6cce37cb3003ac2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f00ea39b15f3350193e0c42cb2eecef42228706be317ed4e20a3d2568cfa7ae2"
    sha256 cellar: :any_skip_relocation, sonoma:        "2722aff367c76246d55a3aaa7bd03f3c62e82d32b187d207a985fd96889afec4"
    sha256 cellar: :any_skip_relocation, ventura:       "d2805ec3c8252348a5a64017922aa2c53aa45e6f42c16fa5d2d14c6787fa9918"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "839cb5fb8cd154618208f23f428c99b721676ca35ad04c4d68fccbfdd33baaee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3abc3db0ebbf689752723b96f9fef541809eb4cb72ba5e4f466b2a900928d5c"
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
