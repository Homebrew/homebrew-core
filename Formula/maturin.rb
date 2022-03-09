class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.12.10.tar.gz"
  sha256 "764d91bb35a41d0fa389f3e8179353c0a7e173fbb52c6d434e2877951f15e4a4"
  license "MIT"
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0e4fe3838d378dc74fd606aa649de9b1c0d394a1a22e9075623cea7f3e96e3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd41d4b9b5b7cd07fd58eee9c4e4d62311a3aeb9e9f2c8fb62c139af52051c79"
    sha256 cellar: :any_skip_relocation, monterey:       "47b135d841cc75ae5b93b44d85ddc5b455a0fbd3c8c16638448fab49dfb1e70a"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e6a923b73e0aa08e324b0bd76a31da7fec63275c1ea364e9020092669df5a5a"
    sha256 cellar: :any_skip_relocation, catalina:       "050b5ff000e892cfa5988646ca4695f2ba0394f3afe7efeba3689993e72afc5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20500c0b0fd4645eaef80eeec2bf4e225ca1b6cf29eea51de19ce85d5f100f7c"
  end

  depends_on "python@3.10" => :test
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
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_bin
    system "cargo", "new", "hello_world", "--bin"
    system bin/"maturin", "build", "-m", "hello_world/Cargo.toml", "-b", "bin", "-o", "dist", "--compatibility", "off"
    system "python3", "-m", "pip", "install", "hello_world", "--no-index", "--find-links", testpath/"dist"
    system "python3", "-m", "pip", "uninstall", "-y", "hello_world"
  end
end
