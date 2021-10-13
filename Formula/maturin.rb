class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.11.5.tar.gz"
  sha256 "33b67e66e725c76eac866c2174cfbe708e77a44d215878474d84bc5f9f6386f3"
  license "MIT"
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8f83e3bf0b9655f1efcb27a28557d6d79678b585f9084437ea4959b56a86679b"
    sha256 cellar: :any_skip_relocation, big_sur:       "36497cced2c8491bf1170922f99f7b1407022d60ba770109f7dac160a9f6a8ff"
    sha256 cellar: :any_skip_relocation, catalina:      "5751c5857222f94b369fb7516292a4cde07f55860a4bedc4fd3357820c579b23"
    sha256 cellar: :any_skip_relocation, mojave:        "5c5c11025a6b9fd0abe95b5de4ac3484cb366b7d40b26f75b64b2d2adf00f2ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c4ec6b51b9ddfb3d9628494ba6d99e55a1c2a62d630dfe50e20e06d047f7fbf"
  end

  depends_on "python@3.9" => :test
  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args

    bash_output = Utils.safe_popen_read(bin/"maturin", "completions", "bash")
    (bash_completion/"maturin").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"maturin", "completions", "zsh")
    (zsh_completion/"_maturin").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"maturin", "completions", "fish")
    (fish_completion/"maturin.fish").write fish_output
  end

  test do
    system "cargo", "new", "hello_world", "--bin"
    system bin/"maturin", "build", "-m", "hello_world/Cargo.toml", "-b", "bin", "-o", "dist", "--compatibility", "off"
    system "python3", "-m", "pip", "install", "hello_world", "--no-index", "--find-links", testpath/"dist"
    system "python3", "-m", "pip", "uninstall", "-y", "hello_world"
  end
end
