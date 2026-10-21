class Chainsaw < Formula
  desc "Rapidly Search and Hunt through Windows Forensic Artefacts"
  homepage "https://github.com/WithSecureLabs/chainsaw"
  url "https://github.com/WithSecureLabs/chainsaw/archive/refs/tags/v2.17.1.tar.gz"
  sha256 "62b6a7a624400f9d038f784ce67d894c033bac9ff9279e658ea960623cb38502"
  license "GPL-3.0-only"
  head "https://github.com/WithSecureLabs/chainsaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "490b8abd20a01e957c982c18f25c9eac7574d5307ec7e38199a94c97a99ddbdf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cc21e84f42a810c7087988407650ad6a2205c24811a3dad1870d5b9b9d559d18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1e8f14b922a8e9cba884a5a0701e0d05f0543ceda9b7b5912bb3fc5f94224e8f"
    sha256 cellar: :any,                 arm64_linux:       "ff0aa8a1c66a0d7c40332a21e691d07c751e30c20418d54e077364056e8eed3e"
    sha256 cellar: :any,                 x86_64_linux:      "aac7af871e29594223ba4deec8b6786c9e587f412ee43b68fd26ba3b2bbe67d6"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
