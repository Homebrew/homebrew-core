class Gdrive < Formula
  desc "Google Drive CLI Client"
  homepage "https://github.com/glotlabs/gdrive"
  url "https://github.com/glotlabs/gdrive/archive/refs/tags/3.9.1.tar.gz"
  sha256 "a46ab3c3c8ca1c0d050288e909717ffb5a6bc9b20635bc90574f7eb29e020f74"
  license "MIT"
  head "https://github.com/glotlabs/gdrive.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f1b8c22a7032181ca4b78e0f35ac41e259019018fe8561bd66dacf0fb4ecf99"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3dca5f854b655f18cce42690a82f4cebf683dd46b2f0b1324ffeb30af97f2b99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "289402bbd8a3c5a5499225e21db3f264d2d692767ba159b3cf2b342dde68bdd5"
    sha256 cellar: :any_skip_relocation, sonoma:         "111a8c2aededae870cffaf71d43b27be5a8bb998c13e04b91a1295cb06610aed"
    sha256 cellar: :any_skip_relocation, ventura:        "2625b240540b94d9fa3804f16a70fcac09512810b2eb0728920304533ff04822"
    sha256 cellar: :any_skip_relocation, monterey:       "00b3557669514a1148e5d28802b1a7d4fadfecec28ae371eadd63446795c3e47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae4d01861608fe3086c1daa15361ea45d6abe57c14845ae2c411eeb2f0d3a3d1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gdrive version")
    assert_match "Usage: gdrive <COMMAND>", shell_output("#{bin}/gdrive 2>&1", 2)
    assert_match "Error: No accounts found", shell_output("#{bin}/gdrive account list 2>&1", 1)
  end
end
