class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.8.18.tar.gz"
  sha256 "45cb521081d467c5a1ee18f53e54ffa62dada359a2d98f5e103908c38f17819b"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69339606a7bece846da30ae361e4725d7df1e5252d1e5c4cc46d32f1bdeb49b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "030e7f468b66cac0cca97f9547907eb0ed75e33dc5e483ac29be5320ebc16ad3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf344fe5f3733d7964e8b789fce4c1582ff62586b71c2d9166d624d0a7274c02"
    sha256 cellar: :any_skip_relocation, ventura:        "34029d2bb6afc9710eae08bf15fe9412aa61036339a1f3dd6e698b64ef11bb97"
    sha256 cellar: :any_skip_relocation, monterey:       "fc9c32b4d256615bdd704c8cdcb444a1d120080d2280b97f10d90b654a4f1318"
    sha256 cellar: :any_skip_relocation, big_sur:        "329c3fb2e08e3d2cd2ac78e585c2f4367aa792bf9c81579de62fde68b78072e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25c1b2c5ca0884d5e9279d11fbf2357636e4910d66b868a8732b8e299f3eb1d0"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", "--features", "tls-native", *std_cargo_args(path: "duckscript_cli")
  end

  test do
    (testpath/"hello.ds").write <<~EOS
      out = set "Hello World"
      echo The out variable holds the value: ${out}
    EOS
    output = shell_output("#{bin}/duck hello.ds")
    assert_match "The out variable holds the value: Hello World", output
  end
end
