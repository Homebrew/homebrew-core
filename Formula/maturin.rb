class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.14.15.tar.gz"
  sha256 "60cbf8ff73a36333c3f5483ca679a52169839db381f06683d8e61a6c00c28cf7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0eefb79314fb11931bedeb63dff4377fb2522594a466e6a8708188bb9862f31b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1570fb5118167a6a0a523a58f5978af1453b563a327b0b8385ff8f52afb86da5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abb032ebf2819fd496f3d4ace018e45968a1eed02a208c1f85c3e7cc4f981e45"
    sha256 cellar: :any_skip_relocation, ventura:        "e6dbf33f2ae86be8c131431e36bf130e0e7319646959149c2cffad25f315e1e9"
    sha256 cellar: :any_skip_relocation, monterey:       "1c65b0e4e28ea3bfb44ea887d548936b2a85dfb250db78ef5f532d393b77298a"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d8af5df58fa4e09147f2690e607a67dbb610cea226568ce3ff800c9e58b3921"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "239cf135743edcb74d7553a8279445174153237ca204a785ef38d11732258d02"
  end

  depends_on "python@3.11" => :test
  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"maturin", "completions")
  end

  test do
    python = Formula["python@3.11"].opt_bin/"python3.11"
    system "cargo", "new", "hello_world", "--bin"
    system bin/"maturin", "build", "-m", "hello_world/Cargo.toml", "-b", "bin", "-o", "dist", "--compatibility", "off"
    system python, "-m", "pip", "install", "hello_world", "--no-index", "--find-links", testpath/"dist"
    system python, "-m", "pip", "uninstall", "-y", "hello_world"
  end
end
