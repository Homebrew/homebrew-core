class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.34.tar.gz"
  sha256 "6d0542a1bec4f9841552084643c11f104472646fc82a280a07fba05ae2df4602"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a80400dfa0b06dee0ccf7425d32e85c99003ecb6b33ce182f1ab34339e3ce4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afae955830e7b2947bc2e0edce537d7f90243bd3dc105c13ddbb3b4eddda030f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a3545ab3843242876ea034329d58274a0bc6ee584f06dd6ac0aeb175e517625"
    sha256 cellar: :any_skip_relocation, ventura:        "15e431d4b635a701eee31e773b2aa300f98b652e61d0f0eee08e9c10a670f7e8"
    sha256 cellar: :any_skip_relocation, monterey:       "d8b311d76175901cbd04838ba9921a1d067427f4823a04c71014b0423ca03f64"
    sha256 cellar: :any_skip_relocation, big_sur:        "1432ea1d679119e234c58873450c7987f0d1b6f14b5404081ec691b85a867eb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7036bf2f91d140e7e11745432f76b262c6116a97d7aec1be141042447e2d62fd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # simulate user input to mdbook init
    system "sh", "-c", "printf \\n\\n | #{bin}/mdbook init"
    system bin/"mdbook", "build"
  end
end
