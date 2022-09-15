class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.13.3.tar.gz"
  sha256 "0fa5f2bebaefe706c12db0fbb15a56a74d0b55a44742520114b84afc1507a794"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "128f517ca116316633aa4111ca1406bc07143696f4be6a31c464131a687ad5e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fee6d0a06b6459c3cf167bda48467e28e15fbfb501c0b767421649b752cfc594"
    sha256 cellar: :any_skip_relocation, monterey:       "cd2d6822f086c4053624f5d22e628fbf4fd04b69c6abc237f9c4ae2a1278eff1"
    sha256 cellar: :any_skip_relocation, big_sur:        "edaf3c29980eaeb4622dcd4484bf480f7d52a723ec595f5ab08dfa624475283a"
    sha256 cellar: :any_skip_relocation, catalina:       "f344af2a8286e5f7caeaf61d3b3bc948e55358fb59ab036b10f111978ff11427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec6da20c576a98ab04c6f35f14518cd1c5835beb5b1f4490174691f8c2ba5bf8"
  end

  depends_on "python@3.10" => :test
  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"maturin", "completions")
  end

  test do
    python = Formula["python@3.10"].opt_bin/"python3.10"
    system "cargo", "new", "hello_world", "--bin"
    system bin/"maturin", "build", "-m", "hello_world/Cargo.toml", "-b", "bin", "-o", "dist", "--compatibility", "off"
    system python, "-m", "pip", "install", "hello_world", "--no-index", "--find-links", testpath/"dist"
    system python, "-m", "pip", "uninstall", "-y", "hello_world"
  end
end
