class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.12.20.tar.gz"
  sha256 "5a1c9ed2acd8ea1edbe7e8b7ed78f2f6887eff77f696dbdd93f81b606960efbe"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eabe60651216871c4c761569173b26fcc1e9d26ef19048b9d4a918aa678afd7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c56fba244ac4f3d8f5f04d60cd89e34d3e65d0ddaa5938cf03592163606d86c6"
    sha256 cellar: :any_skip_relocation, monterey:       "5b8bc1fc57cf55d46fadef53c8179ee98a661be3b61cd28a68c81ae23136c067"
    sha256 cellar: :any_skip_relocation, big_sur:        "791b33f781beb672d113937ab3ff02bd078c498f7b3e590c960b495450e27534"
    sha256 cellar: :any_skip_relocation, catalina:       "4dea92a004cc50cb10888b516174a38d946c688e5e810d1378e4a07cacd81e93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b868f35f93a118299834a9e1433af413b5e939045b6a6228048668d804bf7ee"
  end

  depends_on "python@3.10" => :test
  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args

    bash_output = Utils.safe_popen_read(bin/"maturin", "completions", "bash")
    (bash_completion/"maturin").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"maturin", "completions", "zsh")
    (zsh_completion/"_maturin").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"maturin", "completions", "fish")
    (fish_completion/"maturin.fish").write fish_output
  end

  test do
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_bin
    system "cargo", "new", "hello_world", "--bin"
    system bin/"maturin", "build", "-m", "hello_world/Cargo.toml", "-b", "bin", "-o", "dist", "--compatibility", "off"
    system "python3", "-m", "pip", "install", "hello_world", "--no-index", "--find-links", testpath/"dist"
    system "python3", "-m", "pip", "uninstall", "-y", "hello_world"
  end
end
