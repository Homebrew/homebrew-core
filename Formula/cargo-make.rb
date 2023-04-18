class CargoMake < Formula
  desc "Rust task runner and build tool"
  homepage "https://github.com/sagiegurari/cargo-make"
  url "https://github.com/sagiegurari/cargo-make/archive/refs/tags/0.36.6.tar.gz"
  sha256 "58d3347f2c2f0d32717286e0fa98bfed8fbe77b3865fcd1e4e864927c2682db1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31eee8d343c3eb8f58c17014e0d748a3a1dd8bf328ff40418ff329cd85b80583"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4ef50b5490c2bfb37833ae9cb4c00a7a922c45343825644c4c596dac8159df9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f1c87580d90c2aa80343ed4db950626bb6a0eaf63b76eca3b9e19940c742d16"
    sha256 cellar: :any_skip_relocation, ventura:        "e0a27fde0caab5fb1e59dbfd5a4c346cf767ef46b4218d6c01e1a3800ba62598"
    sha256 cellar: :any_skip_relocation, monterey:       "e0ada3b167c3cb14585d91346771a97bd16d48c3cbe7a2befbf8ed8950e9be02"
    sha256 cellar: :any_skip_relocation, big_sur:        "071468eb1f29c47d258b9b20dfbe36943effd8ef5154845a3eadd13a5033fe3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d79a14cb06fad59c862fe5b7293f3b4aa4ece823dc2b4a5b6a096d55cd8684a"
  end

  depends_on "rust" # uses `cargo` at runtime

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    text = "it's working!"
    (testpath/"Makefile.toml").write <<~EOF
      [tasks.is_working]
      command = "echo"
      args = ["#{text}"]
    EOF

    assert_match text, shell_output("cargo make is_working")
    assert_match text, shell_output("#{bin}/cargo-make make is_working")
    assert_match text, shell_output("#{bin}/makers is_working")
  end
end
