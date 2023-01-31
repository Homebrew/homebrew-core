class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.14.11.tar.gz"
  sha256 "455e9325abdb14bc60967fb52be54b3d567e7c13e1ec4bf208131dbdcad5987c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8e8bd428fdeb2f7f4c3e048bf4994fa3041a65670f9dd723059b36591ae82d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ed356b919e20bb82a511c502553c27ecb66d0187c666175e7125a6335891e6f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d353257e2e73d6d9036640ebf89deafe4bbea9e9e1b0071bda4d41a12dcc827"
    sha256 cellar: :any_skip_relocation, ventura:        "432a3c0327e485ce2dba6aeba797a88dd6cd16874f0ecd392c01a5ed00e9c137"
    sha256 cellar: :any_skip_relocation, monterey:       "89147ce92220a40306466a6c57eb0d59c29acc3fcc8689b6a9b25b899f78bcae"
    sha256 cellar: :any_skip_relocation, big_sur:        "85a5a1ca5dc474ac8788be7874be77199da2df5f1c5ea916f1e39aaa5025eea3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "532f2e170677955dc980479885d9e924cc5e3bac35d2d601f2c80acd31838b9c"
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
