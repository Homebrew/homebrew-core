class Mdq < Formula
  desc "Like jq but for Markdown"
  homepage "https://github.com/yshavit/mdq"
  url "https://github.com/yshavit/mdq/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "25beee2251e1b48970540466bbbe1f15a1d2acf20133a2a13858734b0922877a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yshavit/mdq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2cbe40254385b510ef1774c77dbf19bc02b31474ad65b67aa31d284d995a62e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a554032d298a0cd6665a7baeb9a9cdbd88a637903d0a7fcc6dec69a659a50d70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cf5a1a792d25359bca50391fd3d07f2abd3aeb6c81a7d5995bf314f5f91bc69"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d576c93e97414e66201d4f49c833aaf6c46adfc1700a806a6a56e9d6b3005525"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ab3ce177808cdaa6b6f4609b04df7b3c228f0abc616773e204b35eb381d2936"
    sha256 cellar: :any_skip_relocation, ventura:       "d06c403731a9665b8c05b7e212ed9c018dabd7fdb7a90629bab70d0cb15f305b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fde41d406551a3b5052f9aaf298c217069ef51e3d46d89a6f130b2e2c198052"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "604e57bf2afb7d1b7be2b83fc4bde9135116320bef7938d46e26aef21667f7f4"
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
