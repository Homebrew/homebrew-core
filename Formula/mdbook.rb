class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.28.tar.gz"
  sha256 "b7785a0e69a6628bedebb31257113ae659de3b561458cc635d30d07794284b14"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e73a1b30c439918c52f886ef5e4defa184a33f8bca958489c51a76c216ae38c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2874e11b6af64aeeb7c250e1d193a3c0dd3f268d3aadf407d8817408d2a3bd06"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de1dfe6747c91421c081eb7491a6abf80a766c66ca9ad9f3fa4077b5321031a2"
    sha256 cellar: :any_skip_relocation, ventura:        "81c7a87f9403e059e95a3fd1ab2815ef55e5b46e933360ef3a30d6d38e2b080f"
    sha256 cellar: :any_skip_relocation, monterey:       "4362acbc45631e81d15eb9924cb64d5245d6ef052ee422d95a140569057338d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "486c957fb8a101ad4f13b261df24ef4ff65be3580f5a1e008a2cb35f1070757f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15bde612e954819f7b0189e22b48a916fd0866fe65b153e67fbe38eee5ee3f5b"
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
