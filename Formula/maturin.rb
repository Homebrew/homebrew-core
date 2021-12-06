class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.12.4.tar.gz"
  sha256 "5a636c2f5b08654c09d50f429179d1fe93449474db503100a55b85adbad67dfc"
  license "MIT"
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23c7e03d848eaa3282bd0612a7f9e465becb887ee37ab4c66356e2bf40cab721"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7574e19b6a22d71d769e9c7b1abe7d19a8bef614b140ff07d9e0ef90fea7e534"
    sha256 cellar: :any_skip_relocation, monterey:       "a774b5136c7f25f966cc0f856fbbf0b0672c8cdbdddf9b854c589685ad11d7a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a0ecf04d4f16af4d1681f6a0ec1ac9ef5e0cce52ca9c28fe72151c46fb64371"
    sha256 cellar: :any_skip_relocation, catalina:       "aca5de958931e122c6dbb29bafcdcc3b52b232f378947ad3394428a34be14bac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "713f497877cb80d25581cc4507211a9b190ff26f8927bbd11b386c2bbf016a66"
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
