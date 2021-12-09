class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.12.4.tar.gz"
  sha256 "5a636c2f5b08654c09d50f429179d1fe93449474db503100a55b85adbad67dfc"
  license "MIT"
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b9e008b4fc330ee884ea8ac913443d993a176d0c03dccce6e4729868a7ecfe6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4bf36f95ffa1eb3937c462dbce73edc2c0dbfc657e2dd9c709d02556f1ac85b"
    sha256 cellar: :any_skip_relocation, monterey:       "5ac3588351c9109b768b3ea74cf5d2d8f05c04ad39f86f653530f5ee3eee3a83"
    sha256 cellar: :any_skip_relocation, big_sur:        "772404055b2b6e5e6c3fd04f8642aa56059024660c4ff22f87e39cfea3b98486"
    sha256 cellar: :any_skip_relocation, catalina:       "866a60108b06258db207938ea2607aed207803280a1861a8f9a9c91ed2bd2501"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "369d4c00af67d6521de1ee2801b490bedd9cfaa2ddbbeaf9e1d364a02c3164d6"
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
