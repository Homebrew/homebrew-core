class Gql < Formula
  desc "Git Query language is a SQL like language to perform queries on .git files"
  homepage "https://amrdeveloper.github.io/GQL/"
  url "https://github.com/AmrDeveloper/GQL/archive/refs/tags/0.38.0.tar.gz"
  sha256 "017267ecc80af515a260fe1bc0a1d22eb2a360af8518da15d54aef9e636967c9"
  license "MIT"
  head "https://github.com/AmrDeveloper/GQL.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e52a7c30a6b3d0e2c0da86c2984735bedde904bcd54fa2e713cd974749a660c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1b60f6589cf810a022ad306548e45648a1f3f9cdccf2795bbae0498c2f54a49"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3220ec85145c701f36aea074082938995f6a141f2530a1de15134fe702edc2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa9030a48db8c762085f360f68d8756b113b4927e0cde3ff822eee8f54c32a4b"
    sha256 cellar: :any_skip_relocation, ventura:       "ed25e7350aa63766f12a68dd1efca4c074d6ca53a90c46ec10cd47d3fd360790"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f031dda695346ce5efe06afdc606b3ffefa2d817ae9f5d60e3cc4ca3e3e04599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6693611a27513ed6a334472158a2b3419c477e9503165aa35cc5b3924a78c3d"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  conflicts_with "gitql", because: "both install `gitql` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "init"
    output = JSON.parse(shell_output("#{bin}/gitql -o json -q 'SELECT 1 + 1 LIMIT 1'"))
    assert_equal "2", output.first["column_0"]
  end
end
