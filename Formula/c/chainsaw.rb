class Chainsaw < Formula
  desc "Rapidly Search and Hunt through Windows Forensic Artefacts"
  homepage "https://github.com/WithSecureLabs/chainsaw"
  url "https://github.com/WithSecureLabs/chainsaw/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "70bcb12c6b088a4ae33ff1deb694ca68eaf69094c0c7e515eae7c76209a0978a"
  license "GPL-3.0-only"
  head "https://github.com/WithSecureLabs/chainsaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d68a27f3a5695440f51bff9d879638dcefaf33f30e4de95f0ef4b9ea90bf5aba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92978e35ff07983b57bcef462134c12578952af3499a38610caf146807b4e848"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80b6d06e9229a2b4748525dc46ef23549ab7d2067f97b93b588f02aaa5046078"
    sha256 cellar: :any_skip_relocation, sonoma:        "652bcb8452deb35b0b90efbfc586d551fb25e6ba28398bc59ded47519c5dbd7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66b190ff4b0202de05c78e90bc49589b5db4b6e37991b9b61d31bff731e3e0a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cc528eeb285ff47298c47eb228d8a373cf5eae5fef893541d345de44d21e3bb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    mkdir "chainsaw" do
      output = shell_output("#{bin}/chainsaw lint --kind chainsaw . 2>&1")
      assert_match "Validated 0 detection rules out of 0", output

      output = shell_output("#{bin}/chainsaw dump --json . 2>&1", 1)
      assert_match "Dumping the contents of forensic artefact", output
    end

    assert_match version.to_s, shell_output("#{bin}/chainsaw --version")
  end
end
