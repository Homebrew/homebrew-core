class Mdq < Formula
  desc "Like jq but for Markdown"
  homepage "https://github.com/yshavit/mdq"
  url "https://github.com/yshavit/mdq/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "4d9861053b121501547b72c079b12658b3e7c625f9f44f73671175888f029e46"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yshavit/mdq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ffa709f4502a4f030a7b0e66405fde3614a9aa348724f8336c64be2be16d391"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6eb3463e44918a85f5b208be4cd6b6b5c860d5998c857cd5c2a3625249b66de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "96f7f92418fa81aa243ad941f6632e563454d13519dfdad16a11285c7833a36a"
    sha256 cellar: :any_skip_relocation, sonoma:        "696b704611dc815c013c48d492070428387b1679d4ed1739ed564bb3c48178ae"
    sha256 cellar: :any_skip_relocation, ventura:       "cc441f109510392962138513b0ff801b2d27443a7ff254fbe8b8b47d1cd948c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e3ebe3e845d6c2bcfb02ddd9e5ecdd6b792086fbec3457cada9257d5894feca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c7e72e27ddc7753d15eb1c7c1ae1d2b3336c2a8d0b85d88d84066ef2621973c"
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
