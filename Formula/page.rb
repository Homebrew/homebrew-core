class Page < Formula
  desc "Use Neovim as pager"
  homepage "https://github.com/I60R/page"
  url "https://github.com/I60R/page/archive/v3.1.2.tar.gz"
  sha256 "18089dd86dbbf3b02d8b85412e76f9881a8e2cd957e7201dbbb2b8d71dd5074a"
  license "MIT"
  head "https://github.com/I60R/page.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "297e5a44deb6102021e2b02b204da43603677229591fafe4a5034d106098f4a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03d7a0384cf947530155e49b60922cfb4c5c48cdb676496e8940ff61f065ae71"
    sha256 cellar: :any_skip_relocation, monterey:       "c33a9d4f280da8f74bca54f2fa176c35141c4e5fc5d479e8148fae8ad62156ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "c58e27fbafe7d075bbd1b0f48f3056f346cf9b7b60656ce907b39149730c62e0"
    sha256 cellar: :any_skip_relocation, catalina:       "b5858bbd5755aee33eedfb391b35555d7f14bb0c962ca722fe21b0cdb42e8639"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56715caa120e3060df766e290b3e112da69c5e407547bc9c91dd7e019b4e7eef"
  end

  depends_on "rust" => :build
  depends_on "neovim"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    text = "test"
    assert_match text, pipe_output("#{bin}/page -O 1", text)
  end
end
