class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.12.19.tar.gz"
  sha256 "293e796589cf3dd24404973c67bace3d80b2f44c41c9f04531cb7e4b445431b9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25c6d51bf5f928dbebfd49de9cf1635c57e2746bb049e446b005263d324a78d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c517e9e2d136e78dadf31c7c4990395892f0fdaaebf1c77829d79c1abb68d9f"
    sha256 cellar: :any_skip_relocation, monterey:       "a9b9dc3b2569c72314bed74d2c1d77a1670370eaf523e4b857630c31ce1d6d27"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab636205c502e43cb720f1a8f7ae781bb62609de0e9e4d2da13fbfc6943dccfa"
    sha256 cellar: :any_skip_relocation, catalina:       "cf066d2641a8d49a183c90538a051ac3b1c3587b78e0a530a0449527424b27a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d61345cf0ffecf229264f1708b8aba1c488128b54f48d9aa46d13f35bf8e60f8"
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
