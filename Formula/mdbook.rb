class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.28.tar.gz"
  sha256 "b7785a0e69a6628bedebb31257113ae659de3b561458cc635d30d07794284b14"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ef633a7236d8ff9f1fd4dc8c1cf8ea108c7bc2a3ef5669f380bfb554e02141d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af2704ce2a383e115eabca8a732ebff736803c6001ac714c9a3a9245044a0ecb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "426f06ce9a893197655bc0ba926e4c7cada35913fdd5b043db237e827961e4f7"
    sha256 cellar: :any_skip_relocation, ventura:        "b8f0d0043258c6902bce035ed5276b45556b9ee0c62e6873c16663f8aa04d1cb"
    sha256 cellar: :any_skip_relocation, monterey:       "e8b0b52ddf7e52cad5cd114efa40a1d2256558f52712a3323f05ee4d2d2d013d"
    sha256 cellar: :any_skip_relocation, big_sur:        "72c380c2c1ed5271ea8b06c5d5dc7f5bda60b9a2a18761a90c55444132377da8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb5406683edaf280a681cb9a24477ff7c06c2843fcccd5a7fe465d6f16d98c14"
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
