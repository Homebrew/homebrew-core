class Page < Formula
  desc "Use Neovim as pager"
  homepage "https://github.com/I60R/page"
  url "https://github.com/I60R/page/archive/v4.6.3.tar.gz"
  sha256 "51cf01933180499b27027fcdbda067f0cf80cebaa06d62400b655419f1806d46"
  license "MIT"
  head "https://github.com/I60R/page.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "009fb5f52405281bd8e0bc39ee9617c8d468d6da46ef9518604b976916b0d7a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f5ec8d9d1c1164ed62c3545fe5f567c7e68db21efe7e33d34af2879e1b94155"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36daadd6a77f932fa1bd82f292b71380f677e83079cac1b1a0b85cce395e4808"
    sha256 cellar: :any_skip_relocation, ventura:        "4e3f6358bf5fbd4b38b90c33f3415f838030a4df3caf6517f99a00b034dfec0b"
    sha256 cellar: :any_skip_relocation, monterey:       "42ea36b8eda12ad56070d4b91167b159989850a4b11aa69d6847530956d5d158"
    sha256 cellar: :any_skip_relocation, big_sur:        "71125dc37df4ef17b2aa24a6f039a35988c3ef9817634b6de8d83a8ff65d3a8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27f7441fb37414346775ece63febdd4cc54903c5cba3a044a90b48c907b82876"
  end

  depends_on "rust" => :build
  depends_on "neovim"

  def install
    system "cargo", "install", *std_cargo_args

    asset_dir = Dir["target/release/build/page-*/out/assets"].first
    bash_completion.install "#{asset_dir}/page.bash" => "page"
    zsh_completion.install "#{asset_dir}/_page"
    fish_completion.install "#{asset_dir}/page.fish"
  end

  test do
    # Disable this part of the test on Linux because display is not available.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    text = "test"
    assert_equal text, pipe_output("#{bin}/page -O 1", text)
  end
end
