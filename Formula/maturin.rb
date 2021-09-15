class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "e65864a36be44456da0f9174de12fe3ea02bb87a968b5333ace3b122869dd6b2"
  license "MIT"
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "523755c067e68ec70b4f4cb07d5afddd85ec82ac8ce9b08c1588fae1db0ce58c"
    sha256 cellar: :any_skip_relocation, big_sur:       "414971ce79f82520f64bd249b37ee3931a485bf6e3e5999ad6626b5762a4ecb4"
    sha256 cellar: :any_skip_relocation, catalina:      "0bfd5913be71a7b230d59988c4dd016c5bcaf26ff8aace024364a71b204664f6"
    sha256 cellar: :any_skip_relocation, mojave:        "c7e6beffb511a76b37dabdfaad5aba411e7984c70c92d5b195501a0e15d1680f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ca6329d1eb2be77d7e3b1354a68543f8b919049f00853650cbbd32840c07e05"
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
