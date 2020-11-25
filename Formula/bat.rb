class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.17.1.tar.gz"
  sha256 "16d39414e8a3b80d890cfdbca6c0e6ff280058397f4a3066c37e0998985d87c4"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e593195e2a85c85fd8d462d2cf70d91b2a3f061daee77fff0a5019069d07643c" => :big_sur
    sha256 "ca5eeaae808c8b2eb95de52e80896825022c3790f112904039f1cb4b6a7d471d" => :catalina
    sha256 "c68b601b0e4c5ce0fde06e2799ae51e9209bb844071cc81f4d69b43a8d343a1f" => :mojave
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
