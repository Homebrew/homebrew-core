class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "4ce5735356ab00ae34fbea214f1eaf1971171773c0647d93671bf985d5d16e37"
  license "MIT"
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "caed2e71fad76b6736bef0559c16bb17e7a55d5a2b486b6d787f2aeee48875eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9f97df214bd4c5bb60d696c49c8ca61c9089f224d1090aa078aed4edad98019"
    sha256 cellar: :any_skip_relocation, monterey:       "2703e83fed725eda5c96673567f480ebf83249e26441c1b56f7298504fd028d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6952bf2d7bb929621bc2658925242a4324453b59848adf9d157544ceb4d0863"
    sha256 cellar: :any_skip_relocation, catalina:       "4ec33301c0810b93632d50c2fdc9c4d90846582830ce67a1d7f1e59c38a696b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "454f41ec800dcc2cbb8abb6db958e3e18e336b2731947979201d3937a3254a2e"
  end

  depends_on "python@3.9" => :test
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
    system "cargo", "new", "hello_world", "--bin"
    system bin/"maturin", "build", "-m", "hello_world/Cargo.toml", "-b", "bin", "-o", "dist", "--compatibility", "off"
    system "python3", "-m", "pip", "install", "hello_world", "--no-index", "--find-links", testpath/"dist"
    system "python3", "-m", "pip", "uninstall", "-y", "hello_world"
  end
end
