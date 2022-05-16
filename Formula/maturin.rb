class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.12.16.tar.gz"
  sha256 "ed16a1d751636d63f5b97f5c8e36024fd8aff5553057725ee2168e61e1f9d81a"
  license "MIT"
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fc7902cc990b6358002ee5feaf638ffe05932e14bb3bf3a7d524c3a4ffbac2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28c0eb78c3eb0e2d80351a19b601cab5e4e65f66e33e71659d9f34ef03baf035"
    sha256 cellar: :any_skip_relocation, monterey:       "0b96def4d1b0e48f7cc5e5b2e2618028ec398aaa21d9f4dcd5c335a48ddddbff"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5c2a9abadc692fb5a458db0960af5e4cb37bcb97ac39e8012008c9b14bd10a4"
    sha256 cellar: :any_skip_relocation, catalina:       "0597b32bd4f4f139cc668f027a9185989e2bbc2332dbb5039bc47b70d810c5be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13120e6eb7edfb5de675c86ab08cca64928ea9a700ec990f10eaaab6c36f431d"
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
