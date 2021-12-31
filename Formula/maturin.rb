class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.12.6.tar.gz"
  sha256 "8642e6a64bd088930e666e930102db57b13bc652cc3498f5c2ddebd6359d059a"
  license "MIT"
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cdc8315a5a14f14e19451cca448dda098c306656e762a1ca79954ffcb13466f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83bc8ebaadc4a0b479ec138d921f9ff28070a1d33a99e5020bcf87835c3ec9ba"
    sha256 cellar: :any_skip_relocation, monterey:       "f47ec1c4d128ef18f89b4449feb4e8bc4d1e073a3704c25146de466472f38a14"
    sha256 cellar: :any_skip_relocation, big_sur:        "24add33b2517e404131666fb5634e84302e33980effcc8a876bf66c16293a6c3"
    sha256 cellar: :any_skip_relocation, catalina:       "9ffcb81be230a00e4b62972073d584fa17aa50ac371365a0d6d88d5849ec7f4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8c2b227c310890c383d5988e137e2085cafbbc5708eb663f981e42d17746743"
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
