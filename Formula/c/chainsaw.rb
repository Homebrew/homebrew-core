class Chainsaw < Formula
  desc "Rapidly Search and Hunt through Windows Forensic Artefacts"
  homepage "https://github.com/WithSecureLabs/chainsaw"
  url "https://github.com/WithSecureLabs/chainsaw/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "87a66e39fd6417dfd53d026e72bf2ea9cffc72f3ab5e7b65e633bd4ab95d2a87"
  license "GPL-3.0-only"
  head "https://github.com/WithSecureLabs/chainsaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28ccaff92d365b6b4820a32ef76f9c90e24c3b819ecbeccf8b1473ca33d9c422"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7bac7270712cb90a101409f4e0d5e60e896727c158d30225575e0d2ac54e0e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61310609af62c08441e2afcfdb3650cfb1cf354d4ac1c8c5fdbfdadbdd9adfaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8ed32ee23dbf0478f2c592d01bce6217248a316f38ac9661b449525cc57128d"
    sha256 cellar: :any_skip_relocation, ventura:       "aa3f408a060ef71fe4fbe5756b7b25cc09557d06fc5abab52b09b3c67fe0d5cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f192090857775783e2a9c9a1b492685fbf17b0f5ddc140196ffaa5b17d1969e0"
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
