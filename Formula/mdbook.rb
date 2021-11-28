class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.14.tar.gz"
  sha256 "59fd3e417e9d09deac89e20467194dd9f93854c2f1a87e845816c5cec676765c"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2dcb2871af71310df7b58219d792d597c73fea8f8e0815d271e15d85c318567"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "642be0aa696f8e30f01d7f0be2cc9f4349ea29d0ce82b814b59d5dd66c60f166"
    sha256 cellar: :any_skip_relocation, monterey:       "8e34e2cfc146df32401baa56acb9858b02114cacfd7fc5f5008f97333ba81a0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "9756cd677e68972a8b64ae593e9be6f448a92abc7a791aab53c3eafb9d280a24"
    sha256 cellar: :any_skip_relocation, catalina:       "013c112c01b1c04eb95fdd49201afa61517c129cd9fa8d1f05a894b2a89d3c4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0461e7e6007990395eaa67392f72a5f34e1100e8a220b826a1e023b47177b302"
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
