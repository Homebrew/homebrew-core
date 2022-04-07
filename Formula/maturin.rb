class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.12.12.tar.gz"
  sha256 "0da8b649dc91278363d6a07fee26ea53b8f2d9cd06139034dea3a5506baf12a0"
  license "MIT"
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d5a811d45b9c595f7e7350078b232b9912d138c9db7236269c0db1419ca1a35"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0e463890a9389c050a6218d6f68b6cd83bf863e5d53a3c60973c3dc98d9c14c"
    sha256 cellar: :any_skip_relocation, monterey:       "d570e2e6b271bd5a49000ccbe4909bfb958eb5aac10b32c1885e0995d1710a30"
    sha256 cellar: :any_skip_relocation, big_sur:        "b127d99df46a9eee2e582f57f5a041374aa1b4ec5b1c08c99e96b75508c6ad3e"
    sha256 cellar: :any_skip_relocation, catalina:       "e92b385cc36d4f17e430b98928015ffe67a3eb10bf193d3c4e6153833de6638a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f5147c8f4322d158ba2975d3cd51b6241ba25b2bd59c6dc553fe22108b6fb87"
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
