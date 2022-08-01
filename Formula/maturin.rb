class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "9258fd7ce202ba57956f95f557310c6fcdf6c7715b4eee06630355885d227962"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "930d59c44c29a9d32b905b7687835a0c645e5dc049551943995ba3f64635d600"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27072e5c1d65af7f5056499b20f347ff6bb338a8e70a4b51bfc6331a5fad4c25"
    sha256 cellar: :any_skip_relocation, monterey:       "be719ec7f54fabf0d6c2ebf9d1d0953343ee0d82bd2e77d6140d2381e5357067"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f3aafb8196fd6d076b3de984b40da661184e2e05ba5365e45a0662b2bad8cca"
    sha256 cellar: :any_skip_relocation, catalina:       "67c9e87405dfbcf68ac62f2dfe21a322de205bbf38eeac48b9ac5c37f88d0645"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bab921bb0e08026d110565d342b8deed8fd96b6cefd13bf575d21fb79530edcc"
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
