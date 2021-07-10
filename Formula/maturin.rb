class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "61ce51df22f0b30fe7030fac0161d81c88ea24ab53ffc066842cd6e7536059ed"
  license "MIT"
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "082243e05496c2b78edf9e0327663236d5ba2beb21d47615bff6bb742e285958"
    sha256 cellar: :any_skip_relocation, big_sur:       "1640a1aeba079a87f05cb97386a2bd154143559bce7fb86461191693c9de40fc"
    sha256 cellar: :any_skip_relocation, catalina:      "8851765dfa64f6e3ec6b65c83e8f6db7c3103f3f10f928438d4df3bcd318f472"
    sha256 cellar: :any_skip_relocation, mojave:        "dd0873e9bf03784e0fecde129ffabe9dd03ce3486832d9a5be7b53f7d29ebfc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27f3b13aa13a4a10ec3a5c850947e960e2bb4514ee0c7e9b2165fa35d4081e31"
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
