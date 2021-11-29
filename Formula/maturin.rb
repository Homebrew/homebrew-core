class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.12.3.tar.gz"
  sha256 "9a6ee17bdee33aa319941ca5000016397a2d5343a17341406150c4015aa81b75"
  license "MIT"
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c58358396ade5e60b533a3012b8d401cb0a5011b65dd5b8aa1cdd0b672f2745"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f4bedd39a9f0f65e88dd071f0585676448d5c7b223812baa1f311b1c2fe4942"
    sha256 cellar: :any_skip_relocation, monterey:       "e145be9171e75b3380f469dd850f1dad622bb53fc3cdf7040a828bd04b3b8a2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e5b249b43377cbbf6f330c70e62a12ba8a981ff52f34ba8e811ce120b1753b7"
    sha256 cellar: :any_skip_relocation, catalina:       "0dd35f203f43bf9c6b3e6d516cd8a82f62a323934966b70a57f7d5fd54e55336"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dda6eb3f708d1c4114dcd12a4ea1b7a83108bd70f5eb6cb1c326f760bd6828d5"
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
