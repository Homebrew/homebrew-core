class Chainsaw < Formula
  desc "Rapidly Search and Hunt through Windows Forensic Artefacts"
  homepage "https://github.com/WithSecureLabs/chainsaw"
  url "https://github.com/WithSecureLabs/chainsaw/archive/refs/tags/v2.16.4.tar.gz"
  sha256 "6585bca782e316d0cec7d9cdaaf8e4fca19dc3231bbf1d53cd4d5a9e52bd6bf0"
  license "GPL-3.0-only"
  head "https://github.com/WithSecureLabs/chainsaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d9991a41f7b2151f07d6e9c602a826e1c8ba829a97094ee7f8d97af026810bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59b48bace2e94800af8e4c3cad83876ad4b1416ff1d7864e01604e5182357f1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c5315932ed761a7478ed35a7e18a7ba7603addb48b75d98264ae6caa259560f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f5040932f95559a7d8486c68aeda42a807d4e4647e1c21aca591fe275ef71dd"
    sha256 cellar: :any,                 arm64_linux:   "efabf46fc5a2c508e2291b3f84bd78704ca44a71255d9796fd7a264af61476ce"
    sha256 cellar: :any,                 x86_64_linux:  "f79481fb7c635c60b874c4b8da509bd2381cce352b46cb6100bd80dfc655cb57"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

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
