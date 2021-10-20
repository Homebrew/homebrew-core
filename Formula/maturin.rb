class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.11.5.tar.gz"
  sha256 "33b67e66e725c76eac866c2174cfbe708e77a44d215878474d84bc5f9f6386f3"
  license "MIT"
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "45a33896ad9bb4d49276d3eeb4214037407acb448d1ba650d4d75a45cffa7bf1"
    sha256 cellar: :any_skip_relocation, big_sur:       "ae4309f495a87c1542921abc937df04e7b091855ac86c73ba30a52f64925640d"
    sha256 cellar: :any_skip_relocation, catalina:      "c68d71f5ec9a4dc8bdd8cb25a708400ee24479a34f7d0185ec16441cdcb90b3e"
    sha256 cellar: :any_skip_relocation, mojave:        "f61476bcb6c0bf74237943917a22d963bd1919161457213a047d9ae9bcb0cbdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86ad3e5aa898d1ea54fb6a3b8d66e657c0b8d544a3cafc47770a0cfb74e6d57e"
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
