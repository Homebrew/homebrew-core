class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.12.7.tar.gz"
  sha256 "2ffb810ecb1acba22ff60322cb73b4e487c3684faff7de168633ee6d35022a90"
  license "MIT"
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e040bf19d1da5e5a2e399160ba11201765516efc4b52904eda87b03d3e73afe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "903208bf7506f833d2af5179ba34e59826dae9605a250ec972f9e5302d3eb018"
    sha256 cellar: :any_skip_relocation, monterey:       "f88708b83cdaaaf33260746051cc0f721338281fd2b940568a2ad90769c06716"
    sha256 cellar: :any_skip_relocation, big_sur:        "7aa2ac0649bf0051538c86f6cc997802a2e121a13092e6297f53a033e1e9c390"
    sha256 cellar: :any_skip_relocation, catalina:       "eaeb61015b9c773c6ff1398e064b09eb3a3b15892aad45e6f55bf45b2d174860"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc17d20907ff5370a67d47d0ab58b9dbf32b2375820ca8a47970b14ab0d0c2a1"
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
