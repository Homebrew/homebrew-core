class Mdq < Formula
  desc "Like jq but for Markdown"
  homepage "https://github.com/yshavit/mdq"
  url "https://github.com/yshavit/mdq/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "6a25fc95d92822d093316d5a62fcd090218a4e63b7d3e568d460bd49439a0570"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yshavit/mdq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33f3deb5207555e86554e7033d5d13724114e37c28450d07a7cc31a7902033ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de5326001e98b3fd86ebf1b7a9100d86cffdb51e4d19a061d1aab039e5e78151"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "abacf362a4e59e4b5c52e8e31e58f5481bcb0f4ced8c584cfbe8517117ec1f23"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ded3d9a3efbe1cd923fa7da96aa06ac134e829683bcdc7f63d7f10de6b24d4f"
    sha256 cellar: :any_skip_relocation, ventura:       "c253e622bbca266ced0f06b434480ecc68369dcbabf9b333dba98dd8956293d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3aa4c2d50d0711094b1435e555a409e9ed560d927f9d540b296ff41823e3c3ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94ea1f1ec41247632a673bc739612a0c809f1a6653197c9b80253047e5452794"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdq --version")

    test_file = testpath/"test.md"
    test_file.write <<~MARKDOWN
      # Sample Markdown

      ## Section 1

      - Item 1
      - Item 2

      ## Section 2

      - Item A
    MARKDOWN

    assert_equal <<~MARKDOWN, pipe_output("#{bin}/mdq '# Section 2'", test_file.read)
      ## Section 2

      - Item A
    MARKDOWN
  end
end
