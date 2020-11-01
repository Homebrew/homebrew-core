class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.16.0.tar.gz"
  sha256 "4db85abfaba94a5ff601d51b4da8759058c679a25b5ec6b45c4b2d85034a5ad3"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4bd522806fe7f6908245788ea041cf0eae32d012c883e57ad1ab137ca7d34fda" => :catalina
    sha256 "406537250c9d3c7ea2bfa64ff7cd102c86f9204a5cc731ebe5ce7c6f11e41320" => :mojave
    sha256 "10f22366b885e9a10d47f21de5c658dcb8189301cee8722974294a5451c0d80d" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args

    assets_dir = Dir["target/release/build/bat-*/out/assets"].first
    man1.install "#{assets_dir}/manual/bat.1"
    fish_completion.install "#{assets_dir}/completions/bat.fish"
    zsh_completion.install "#{assets_dir}/completions/bat.zsh" => "_bat"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output
  end
end
