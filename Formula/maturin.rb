class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "3a15ebdb8780a4db1603c887c5bc4ba8aa689bbf6914d8d9852d05ec57e2464c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98a3ce31007d5f31727f8ee46e6793ee4982143eb79b037a1f7d1b654fb7b432"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56e7c93d4ceead71b53e20360751842ebe7539dc2e5f8314d142bae373ce47e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5e9c06677f77ecbeef775e07cd467b83374f74b61034643da036f99abe77bec"
    sha256 cellar: :any_skip_relocation, monterey:       "ef269e27f572a7628fe63629ec3880f7e7e006315c81c76407db9e6584e7b836"
    sha256 cellar: :any_skip_relocation, big_sur:        "b10509e85e0dda2be3d5931a81b2c09d9f48b4588548d0f0105477c1ef150a9e"
    sha256 cellar: :any_skip_relocation, catalina:       "3518f8a4cb3046656dc100d671a46b74878d15f303194d3c860b061c07c7623f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49702603696175ba3f5bc4ae7134575f35444f9ebb34d6fc3c68b7ce41b82d10"
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
