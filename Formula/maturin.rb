class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.12.15.tar.gz"
  sha256 "aa640e1620dc466778cd48f0c9cefe08a9ade265c7f0582b005c25e9f1518be4"
  license "MIT"
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdc79157f995fefa55dc049e2ac89b840385edbb775d988f76fd1589e818d4e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b274fcf5ddd88f2c27e9c483ae158a42afb0fe3d1e9c1008558285b8d1de185"
    sha256 cellar: :any_skip_relocation, monterey:       "09f57b38c0328f7a57bcaac76361a7703496a1c501bea3e0c5ed6446290f817c"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c36b5f361f7ae3dd2ac3f2466e425aba9bf2733d2205a2e2c77c2122fd0da75"
    sha256 cellar: :any_skip_relocation, catalina:       "7577aa5ad883cc98d42b72310538c1673beee12487a2af8a6c09c5167afd7853"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a20628e7961e83745d2d34234eb14f994b98ea44ab1c9d7ecf757ebde1225357"
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
