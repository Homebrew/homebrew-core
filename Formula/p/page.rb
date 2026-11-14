class Page < Formula
  desc "Use Neovim as pager"
  homepage "https://github.com/I60R/page"
  url "https://github.com/I60R/page/archive/refs/tags/v4.6.3.tar.gz"
  sha256 "51cf01933180499b27027fcdbda067f0cf80cebaa06d62400b655419f1806d46"
  license "MIT"
  head "https://github.com/I60R/page.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3373a45d3834cc25e31dd9c9006f67a1eed9ca8c517b30db4fad320338a5a67d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6b5eefa61608d2e8337d042b66d9308669af5d6b3230939aaba417077873740e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "239c14d9d4ce61a80f06207c0d532fb7663a4486626e474f35a93aff7d7631d2"
    sha256 cellar: :any,                 arm64_linux:       "3dc0e7de59b292e82863aaae5b54c3e1fe960a0131136579f53d65920c97f74d"
    sha256 cellar: :any,                 x86_64_linux:      "2b5accf53fcdde073b7a96011a72cb113dd1a92a7f2866e499cc58bbda5ef2a0"
  end

  depends_on "rust" => :build
  depends_on "neovim"

  conflicts_with "tcl-tk", because: "both install `page` binaries"

  def install
    system "cargo", "install", *std_cargo_args

    asset_dir = Pathname.glob("target/release/**/page.bash").first.dirname
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
