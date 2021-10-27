class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.13.tar.gz"
  sha256 "12a88a08e5c5b26810cc33b4e0ebed7cc72394f9041e8b15253e3cfac1223a7b"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f937d305a9416b6b1c1e34d2f7e5685f61022f69228349698a5012d3dc56fd79"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9561cf4600591a7832591d906e4992e3d18d6f40d8b1672d103877af058cfbe5"
    sha256 cellar: :any_skip_relocation, monterey:       "4cae52f5b1a86af39efc47c99f086de16d1fff57a8320b44659e4d8e7daffcca"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0ca7966601af810e8bed831e3ab0729469f9ce3d525117dd2de663d531621fe"
    sha256 cellar: :any_skip_relocation, catalina:       "55bfe16440b12b5bc9d1013aced30aa66358c0160d519083cd44d1bb679a6505"
    sha256 cellar: :any_skip_relocation, mojave:         "aa9be33d9d55d5ef7a2f1f3457cd064f3b9dd782274e3a1a54ab584aee35b81d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0671a46eabf1310248f560d85cd3f84148fd362c08fcb95606181eb196263811"
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
