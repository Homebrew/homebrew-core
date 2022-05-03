class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.20.0.tar.gz"
  sha256 "12eca3add56f21b8056a4c17cfb5bffc45e107f23f75a8e0f5de948d8e997c39"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/bat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cf2fa7f8e76d0bb98eb3424f092c4fc7ee28c8dc076ed4647381f7a9dd93425"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2fba3298484fe353699cce3032a7d1693b5de08d860f2879b4b8a9e56b4535e1"
    sha256 cellar: :any_skip_relocation, monterey:       "9e9b1c64c0bb01e297e8f1f17dc697404b5da7f345876814c519339421f35968"
    sha256 cellar: :any_skip_relocation, big_sur:        "13a029946de4c9617371a65039081d83d04002014ac8f87511b42b16fa643c78"
    sha256 cellar: :any_skip_relocation, catalina:       "53e1a8a0aa3c32c7df50f75468b0373afdada38528579e2c15213e60bc63c2ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "824358bdeeba4b1ba7c2c0224f8882a23a668fa8a5d4dadb217e00291f40d308"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args

    assets_dir = Dir["target/release/build/bat-*/out/assets"].first
    man1.install "#{assets_dir}/manual/bat.1"
    bash_completion.install "#{assets_dir}/completions/bat.bash" => "bat"
    fish_completion.install "#{assets_dir}/completions/bat.fish"
    zsh_completion.install "#{assets_dir}/completions/bat.zsh" => "_bat"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output
  end
end
