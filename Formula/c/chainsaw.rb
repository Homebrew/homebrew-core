class Chainsaw < Formula
  desc "Rapidly Search and Hunt through Windows Forensic Artefacts"
  homepage "https://github.com/WithSecureLabs/chainsaw"
  url "https://github.com/WithSecureLabs/chainsaw/archive/refs/tags/v2.16.5.tar.gz"
  sha256 "fa376e837cc2ebb830a0d59d1e6ab2adf60a2a85b1c2c71594bc3f41d6810aee"
  license "GPL-3.0-only"
  head "https://github.com/WithSecureLabs/chainsaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fdd6789683855046d0444887ad19bf4a07ce642b2293809c8ed8448c7c8273ce"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "401939b617a50706f67b42cc1eb21b15732df15321baeba07cb8066bb4e126c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8703f506d74adc6597d056dcb9fa0a146d23a03665007915cd0722ae7c6ee98b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "99ce325b4c6f6b1be0de2cb64ec1a7d88d95e987073265243ac8a5055627b428"
    sha256 cellar: :any_skip_relocation, sonoma:            "bcbf04b24d4f2b1b0c819f7bbecd65bdda08faf9775f1f8795a3ed6364704203"
    sha256 cellar: :any,                 arm64_linux:       "82817dbe59ec20cc55bb5dd8df0eb27a794b1843bc7e69622473bc64fee32688"
    sha256 cellar: :any,                 x86_64_linux:      "64c60daa5e6e0ecf45218ba96a5acb7abc9c5c9b085d43a0f63bf93b92303606"
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
