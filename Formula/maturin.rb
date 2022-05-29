class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.12.18.tar.gz"
  sha256 "b6bce7879dbddd254c51f0641455511a42848925b6fb2a238bd0dd9503c24513"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91f552f7286d8183604c897d142df44108d654afaa6dce93698df5e431bc4d2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63aeaf667eeff3cb8977eb2397a2d987a1ade5fa5a1acd66e9d468d3f7473a5a"
    sha256 cellar: :any_skip_relocation, monterey:       "e567a44403de51ef2e891bd4fab7d075aca3524217482c83892d133e3ca6a12e"
    sha256 cellar: :any_skip_relocation, big_sur:        "57556183eb6c9d059ae24003cf566098efcb2926706b3954046c63e94860dbbf"
    sha256 cellar: :any_skip_relocation, catalina:       "5cfff3ae96de63f4ea0a2aecfabdba1a1784128827e50e843ba279be09b73c1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb9cf28ba64bf7f207bebaa8f41fe6aff2bac52d2b6f1accb3b76de5804a0ef9"
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
