class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.12.11.tar.gz"
  sha256 "4d39f15fae9c01f2f23a544fc26b20c68693ec03f820b30ca5f505647c452be1"
  license "MIT"
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fac079cff817c2f4a99f1c9a864eb54a851e1061499149b52f056952a34f6ddb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7867aed70fdd65c84aeb078e538affb7482622c9e6b5ac91269ddaea067dc5c8"
    sha256 cellar: :any_skip_relocation, monterey:       "a0802ede460702945a37de5fe1759e63051c224a543e26a2262950d3df0dd24e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a9c2f415c0b90eb59638322eff2624165c1e44cdc7f7726002e7bf9c0b77de6"
    sha256 cellar: :any_skip_relocation, catalina:       "5845574511f4a22cc987e8d96841c483e2a82ff3fe05db64cde6a962539434c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f5e9f72114e957b889ae88805c780676c8ac2da08f1d9acb2113f31caf61ebe"
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
