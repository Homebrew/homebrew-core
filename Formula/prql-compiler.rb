class PrqlCompiler < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/prql/prql/archive/refs/tags/0.3.1.tar.gz"
  sha256 "c086c47dd501806727b0d1c741e2d6d747c8e4f00c0a55647f381c8225259740"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ec97069015c9edfdd5835821ba81ab5e519f3eac38c3ceddc449fd0739bfb5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b7364e87c66615c790bfad42884277cdc6f7c3d7ec11dbda46195e47dc12ef1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48e2613a38c5a91bca876857af4754919147b8454ab9432c55741e6714716ad9"
    sha256 cellar: :any_skip_relocation, ventura:        "bfe6767e6b2b8dfacb1f11ef390de5bd12f593eb61e03d249c605f0ae53e3a59"
    sha256 cellar: :any_skip_relocation, monterey:       "fceac83c552ffd746e23cbf9592968d62ed13fb7808856d21c8cc883fb21223c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0101852dafe91b32c84cd69459714ff783dd7d93b5e0320d9952a8da1815037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7c543d527ec5e544228bb15e1c43d2e868d735a06362ab693877a6c0235985c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "prql-compiler")
  end

  test do
    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prql-compiler compile", stdin)
    assert_match "SELECT", stdout
  end
end
