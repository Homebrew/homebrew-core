class Gnvim < Formula
  desc "GUI for neovim, without any web bloat"
  homepage "https://github.com/vhakulinen/gnvim"
  url "https://github.com/vhakulinen/gnvim.git",
    tag:      "v0.1.6",
    revision: "7492a385856b2d2e142d9cbd10a4dcaf0ccc16fa"
  license "MIT"

  depends_on "rust" => :build
  depends_on "atk"
  depends_on "gtk+3"
  depends_on "libepoxy"
  depends_on "librsvg"

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args
  end

  test do
    # gnvim doesn't support headless mode or calling vim scripts, so these are very basic
    assert_match version.to_s, shell_output("#{bin}/gnvim --version")
    assert_match "Gnvim is a graphical UI for neovim", shell_output("#{bin}/gnvim -h")
  end
end
