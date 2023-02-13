class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.27.tar.gz"
  sha256 "c0a13e76b18401d4662b3a721c714baf6b5bd08f799f25e4cb9d920a75c7cab5"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3011a0c850a5ac4d41f4297f65c6a69882027ef7602b3bd162f36b097f038aaf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de1e131ce2322c8c5c17baf8b9c16a5a4d5ad2c57f778204598af2ffc731f0f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12ae068a045aa5e64a93b89e26e081f862acf86f353391bee79fada041cf1885"
    sha256 cellar: :any_skip_relocation, ventura:        "2924e65436fa33bdb0cc03b2071cb19fcce96e10c29fbf429e05fbd1d44dc194"
    sha256 cellar: :any_skip_relocation, monterey:       "3acccdb9774a9f12ae0d6223d7c161b493878ba9f8fae303a9949f8a3bf2b035"
    sha256 cellar: :any_skip_relocation, big_sur:        "edae0197f4b5d53d404fe2719a33f169f83cf9e85c9eef44b1b865fde8614676"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "598523a335bb06a10e50e749a00472aeccf5ffcc800079ff164e85e4f46c01fa"
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
