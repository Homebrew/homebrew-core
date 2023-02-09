class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.26.tar.gz"
  sha256 "2f92db133b873c768df25fc4225d3d4c63f869d5b1657069fe78b6ac10cca2fd"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db02adce0168412000c03d341e0d29a773a598a4731cfb7faf8c9da98e9c0eb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91b055c7775307dbe025c49f6afdcf4e2a3748f5c9fc7d73976476743aedd790"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "713e4afcfe77290071b42b677b60642b5566fa4fe42e8a79fc9756b16e3f933b"
    sha256 cellar: :any_skip_relocation, ventura:        "cc5231b665cc25777503203e12b51786637918abfe7495a597732011df8f3e8b"
    sha256 cellar: :any_skip_relocation, monterey:       "eaf1e3a2a659be9ea763840d4d6ee5027cf7ccee4d69ecb9908d1e837cd5727d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c30e413a5a9240b5c0c838b08fe02ab9a223b6c1ae1d549312d492f2e0f2b986"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36155ceb139e2d0c9b26d2a8be9da128ee52552347412511ec2031ee5549a95f"
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
