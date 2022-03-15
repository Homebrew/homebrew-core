class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.12.11.tar.gz"
  sha256 "4d39f15fae9c01f2f23a544fc26b20c68693ec03f820b30ca5f505647c452be1"
  license "MIT"
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0d2634402e9bba411c28f2a480e02064bc70a75ecf9f9f483fc7be9d9489f1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b26b89d732ae6fe70988ae225776266769d78dbc62e4871091b9c68009f1c30"
    sha256 cellar: :any_skip_relocation, monterey:       "ca9e47bc6cab55608248fcd47cbbd17441230a185b381edd58aab62abd2179b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d799609a4d5ec5d853f5d87093c62211e2fccdaa35767bb930fab6888c8c0e6"
    sha256 cellar: :any_skip_relocation, catalina:       "4ad8315f277b19c204944e44bbf3dee3ca6b57d1b81ce03205b943a63967a468"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91bef81802b6eefe58bb403700ef6345a95a7198c8f40a6ae7c9f1ef487320ab"
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
