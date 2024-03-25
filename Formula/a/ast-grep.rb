class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.20.1.tar.gz"
  sha256 "1ead3ba79bacec1065c5c035e4adbd1597d9ae6ea42642aa7a21c3b2bd9fb786"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "629ec69be98dfa6a6efdcbad2c70907048a7860c22acf244b66cdd85a0b68e94"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "457dace6f82137bf149586e624857d572538c718635404d1e3cd1dfd9b7ce751"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a82eb36c8ec55077be47d1a33bd2b52989dc2d58d1f41e6159c07105f40e67c0"
    sha256 cellar: :any_skip_relocation, sonoma:         "1bff93e7ef4dd1dcfd76f667f41d6c1c02d61f9e3067a543ac1b674335317b3b"
    sha256 cellar: :any_skip_relocation, ventura:        "3345736bf0ffb8831903bb9267a8ca8bc969e006b637737e57ab23c81b8c1132"
    sha256 cellar: :any_skip_relocation, monterey:       "cc1ce8b895aea06476717e522efd999e12ba4b4d451325c2f36f6ee0c2854c5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52d4bfd3bc57e2b843e5b8efc96f5efc1187960ac1b66858ab1ec222c8b54bdc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"ast-grep", "completions")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system bin/"sg", "run", "-l", "js", "-p console.log", (testpath/"hi.js")

    assert_match version.to_s, shell_output("#{bin}/ast-grep --version")
  end
end
