class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "d66d21703a78d71061b279b97fb7dd15a925474da19bce9928d87f1c22550ed6"
  license "MIT"
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5067311e5cf4ad2e9a55d5d0bd5df4296e608e04503b1d93ff372dfd597f88b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d328bd8916d51ee9514cf2478334234d62b3cb64da77925b209222579c81225"
    sha256 cellar: :any_skip_relocation, monterey:       "24fbb1e026116726ce1528862e804202d7231a54d8e66b7153b0030eeb0ae40b"
    sha256 cellar: :any_skip_relocation, big_sur:        "521543575884e1099f6923d60ffb242d37e3f6542b00e69ea124fe0577c7f51a"
    sha256 cellar: :any_skip_relocation, catalina:       "25927a7a3ee7dcbc279c2063f869ab6e9c5f6af93fb4aa9afe7e9723b082897a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "614d1bcb4a3916fce27aad2dafb8dfbe6cac7cca621342d085a8066fb075d8ef"
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
