class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.14.5.tar.gz"
  sha256 "444e302f2ea55c95cf032453022fa075986c20a03ea6b5ec901a15c19bb89b6b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9fb9ac0edd106ec73eaa3a94bd5f1850a5a56a063b74b2d4e0ce55575900c38a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e848611e84e30a3191e6e83f77bd32e17ecb249fcf4c8d5a016d680e55b3f5c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ff0cfa42d5ec689894dbddd9738f38408e0ec3bfe54b5eba0ae0928b06abfde"
    sha256 cellar: :any_skip_relocation, ventura:        "d3a81de59714327a2e086a4dbd451dd5f0c5ff598caf99a13810308266a36432"
    sha256 cellar: :any_skip_relocation, monterey:       "03c3cebf68059efef2b33787029b9a59f738d2a67d22fefccbda2e29fb4b079c"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e69926113c03be1bb665c8d04f3d45e387f7dc7c3dcb5f9db337dcb7864afe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36bade331e25d305b8fe6d44611cbae479a60c78133a0c81637dd334c757c578"
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
