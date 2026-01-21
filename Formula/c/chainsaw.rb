class Chainsaw < Formula
  desc "Rapidly Search and Hunt through Windows Forensic Artefacts"
  homepage "https://github.com/WithSecureLabs/chainsaw"
  url "https://github.com/WithSecureLabs/chainsaw/archive/refs/tags/v2.13.1.tar.gz"
  sha256 "ab372bb555b5a39fb2763c2409ebf272cfa28e241f35ca960d3d50c678850199"
  license "GPL-3.0-only"
  head "https://github.com/WithSecureLabs/chainsaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "960ea01eafda5c685b6ad706bb50cc4409d6b948bb8a61753bf684b4d2451eb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "271499760db41371da2ae96a5d0f71a439229e041b0de109fcd6de5906967477"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0698c0872d94dab76f819b4aa9cb745c9ce65f23ecd3b8d970615d647bea675a"
    sha256 cellar: :any_skip_relocation, sonoma:        "360897aefbfafb29ea194a1142404d2af6efff31feae54ea68358f4ea8f8aabb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "019bdca5c0944cd1b1c5ac89661d78c4b2f8e95978ae3e936ac8b7137461f964"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7264216d9d1a71105738bb626d3091000fdb4b135eaab2e1aca999518371bd22"
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
