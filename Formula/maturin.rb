class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "9258fd7ce202ba57956f95f557310c6fcdf6c7715b4eee06630355885d227962"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4c2f24fc40496a8950711f833f929f82fa3a3efd4c3ddb2c0e19b75bf391264"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37ed408cf8926d196e5558ffb7f98fa3750dab8b587cdd161b33a22475c81e33"
    sha256 cellar: :any_skip_relocation, monterey:       "558f7de845744294934abd17182ffb701d8383ae85c4f34bce10e20d7863a12e"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b82dcca7c1582bda6ee466966c1c734c6120988de5c4d49eb7429c604dd2604"
    sha256 cellar: :any_skip_relocation, catalina:       "9a0364f7de73de37a6470d57f7851c7b086bf81946122bf884d92d7e5f8b1645"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8733fd68f82cef6a55d7ce41ee4e79e408f9271aba13ef4b626509749fba583e"
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
