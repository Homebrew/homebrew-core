class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "c4141615078313a5afbb581fefc4b3673c24466d37c939dc44a816a265067c74"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "551058dc7b2bbc0d2832fe70c23f16000a1f8df30427e4da7871d3e5c4f5dbe5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "435644d34b26bb12d4aa35e5da2c2b5a97d74da8db807add00c798a77e8fb730"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5564f902a0803146ac708c63f76566299df2f4d001e57629ef9c32acc83e5b9"
    sha256 cellar: :any_skip_relocation, ventura:        "2b03e28ff2ddc747acefc3b782bafac5b93ea9d596218eac0f7c0dab3c31bdce"
    sha256 cellar: :any_skip_relocation, monterey:       "6eddc20ccd58d79259e59e88f12af515187565689187a14fda6545148a28a9fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "38da5e2dbe59ff88a638517d592f1e11e26be456ebebf0dda161fe86a46dc63c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e4efb4316846ac8af38dbad860d9e955a0e04672b9f44aa544ea8a907d4f3d6"
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
