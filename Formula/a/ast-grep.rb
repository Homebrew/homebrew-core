class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.32.1.tar.gz"
  sha256 "ef6c6518cf1b7716f677a27c6f8b65f55aac83e1769c787dcd4c459aebc7c7c8"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d776c56c062c974e0d65644f53cafe9a82084e38704226cd80ecedfa92f6eacc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2df64a6d01b6bfde1ac881434d00033492e0e797f2111877ac24ace10af4a5fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5205d0435ea83496c272e7d958e3c49c9f5aa636a34000b09b2304ff056c1c4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca1a816464198dc0b1ffb7e1f15b67502b7f151e8afa6939332915b8fa311446"
    sha256 cellar: :any_skip_relocation, ventura:       "7c565cde150ff3949f6ba004d9169dfac2af2c3dbae23b51e3ac8660004a8998"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "004c0cbfe3b31b4910a127a6c6b85a2eccfff3b6dfc00285e24ab7ff68155219"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"ast-grep", "completions")
    generate_completions_from_executable(bin/"sg", "completions", base_name: "sg")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system bin/"sg", "run", "-l", "js", "-p console.log", (testpath/"hi.js")

    assert_match version.to_s, shell_output("#{bin}/ast-grep --version")
  end
end
