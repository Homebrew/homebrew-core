class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.14.17.tar.gz"
  sha256 "d47bd483c2748a64d245b4ee34d32d869a30bc7683f2603487dcd54ff08cf846"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1434057b9896896a36d10aa97d857b3b824d28ab7bbeb12f47dbbc0bc6fb7733"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "544c418c2df9633b654a9de320b16f605324e359c60a03342a8d8897b5a5416b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc2844be7b442a1638635db6bc4101a7431fbe6b4bcaa61c7c285d543a126d42"
    sha256 cellar: :any_skip_relocation, ventura:        "2ffae98817d513bac2c55fc68cdba0f510a4bbbf58fb2848e17f2467c4ea882c"
    sha256 cellar: :any_skip_relocation, monterey:       "8d8020f8f0c05f12e413c22859daff8820627b5160e4b0974ec9d7caf7d95745"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd37cca55a912fdce3597f3b3b7cd946d06cb10096a4af8fb489cbbc0b3c340f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f6ceee11df68316d23310d383d03df28e6953fd4b83013a71498de9b561f61d"
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
