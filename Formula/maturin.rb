class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "58570326634c1e51b774851a777cda8fa70ad7f6f0218c29382ccf7fc57b595f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "703249a73a14f5a81346598063c4eba1af5451c25b0385958caa69fed0dce66d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f8a4989e55bdf468981447a85971294d27914df910181ca073305e60e1ca012"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5216c708fcf37ee90de0807133a2627ef4b876523f1928c4f0d0acffb043cb6a"
    sha256 cellar: :any_skip_relocation, monterey:       "c603fd62a3632a3bfce89c594782a7f8b8da82a9c27d8865d419c1e2d97c10d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "15f90d017eb8c3ee24b70ef978cd927aff224182c062219f9428aaafb7275727"
    sha256 cellar: :any_skip_relocation, catalina:       "488b06070dd32d0f7d6b6e63485756d3a57556d60e1d2a765c22741a3070c4ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6870d8565a59188864714c4282e263ed8bbd26c6ecd9da25650ea7f6235129ef"
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
