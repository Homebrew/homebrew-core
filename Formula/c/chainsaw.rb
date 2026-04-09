class Chainsaw < Formula
  desc "Rapidly Search and Hunt through Windows Forensic Artefacts"
  homepage "https://github.com/WithSecureLabs/chainsaw"
  url "https://github.com/WithSecureLabs/chainsaw/archive/refs/tags/v2.14.1.tar.gz"
  sha256 "1706b4e73941e79776b9131f67c598b5165d011444bdc8bd0503efaf93547392"
  license "GPL-3.0-only"
  head "https://github.com/WithSecureLabs/chainsaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc824dca00e609d28135a05f9d538f28e1337f01f11df6e662c7d432a0dfca98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89166de0b4ba49c3c634bfe6730bd36677d1af7587e18560ec08509065d85dc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f77849035ed31bde08e21dd8998081ea4bb3aaaf363598e302ceb6091b0b4cad"
    sha256 cellar: :any_skip_relocation, sonoma:        "c37d0e01b535a21c9e3833bc852fd64c6069d58135ad4fe2e4070bd9d8818431"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e9055460ec73c0672e909be75ddb756b55de58a6c4a3d1234e5fe441023509f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f7afd7f9fc0daeee1997a6a8d51ce76ee2da2f3f4cbe787bf214b68043c5f70"
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
