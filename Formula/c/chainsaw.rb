class Chainsaw < Formula
  desc "Rapidly Search and Hunt through Windows Forensic Artefacts"
  homepage "https://github.com/WithSecureLabs/chainsaw"
  url "https://github.com/WithSecureLabs/chainsaw/archive/refs/tags/v2.18.0.tar.gz"
  sha256 "2f30875fac34ca8482ddf3de888949f94a5983cda35e4ee81abe78e19175c87e"
  license "GPL-3.0-only"
  head "https://github.com/WithSecureLabs/chainsaw.git", branch: "master"

  bottle do
    manifest_sha256 "52729b72265864c83252fb72515340dde25d32e20081c22a9a7b07aa7b1a9fb2"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0b728684fcfe4e10716e1ef2272dc2f447eec097db3be31ce458f6d386d9bb9a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6cb643a20618d755be4009ff058fd2ab766cdc995ba5622f608881b332624d55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dc4fd5a7f779623eac609143daa376704da1b3c82276d2ae8cd84baecd07446e"
    sha256 cellar: :any,                 arm64_linux:       "0f6c1282c4b9192bdc1e333cacd331c78bcfd414726b6cee1b09cd03ccb41f74"
    sha256 cellar: :any,                 x86_64_linux:      "30c3fa969b93fea3bad35efed4c5c2fb421ba2bf1778c15cd7f3ec3194797a1d"
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
