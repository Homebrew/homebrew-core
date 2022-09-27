class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.13.5.tar.gz"
  sha256 "5243a78e8e229c947167dc29303bc963e4b33e3179ddb1c6609f1c7e235d1cab"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1dae021064b1815093f3b24362d127dbd4fab5b366a9d947892b013ca1f23196"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a15088554fb56620d778cf199e3e070833fbd98bfe02a3f375c339f570905550"
    sha256 cellar: :any_skip_relocation, monterey:       "da6753f004ded7bfae950e0927fc270cd22de52e18edd6c6b0ec0bc83695effe"
    sha256 cellar: :any_skip_relocation, big_sur:        "7de6f2f5413c6d0a9c7b288ded5dc28ad4983fa0dbb820608536928885560861"
    sha256 cellar: :any_skip_relocation, catalina:       "3e1bf045edfa5e719e1fcf144f5cb36e04e60f619183bd489d5922bd3e1618b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3952c0c01a64345533436e752242135b1af13008486a7f70fff0179f8e869e0"
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
