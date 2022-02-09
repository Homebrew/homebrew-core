class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.12.9.tar.gz"
  sha256 "26b094c20c9939cc9df5632b4b8d8921c4086b27a4867b439297e616f5781716"
  license "MIT"
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "620d344ceef92f4fc432e1e3b2321dbac46579b07c59a95095e9aea41df91fa9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fede2ea64b7fab45d36012ddae877f105e2225f49b99adfcc4d153e4a2debcde"
    sha256 cellar: :any_skip_relocation, monterey:       "88943133567936115af52ad4fb4019b435c747f02dd612930c97461298c493fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "04e4f664fa1b336e02dd245cc0c198bd4c7159be6034f76af04af03fe00359a8"
    sha256 cellar: :any_skip_relocation, catalina:       "c5b46a1241d10cffc16e0fcf9f393478311d5246d4923eef741c2e71c0f8f1f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "940a059d8115e85660100a7967cf90577d260844218e48d476b802296d4b306b"
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
