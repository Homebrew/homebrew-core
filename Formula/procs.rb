class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.11.9.tar.gz"
  sha256 "9d17be4c9d733723da6bfd13417a5f73d0f6ea32802db6d94da8f377a4872b6d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "043b84aa56abfde49ee039d289d61a509d22aca391d38d89fe76c0c7a0cfaf71"
    sha256 cellar: :any_skip_relocation, big_sur:       "bfab01d261a0c4cddb58b37910e1b468161d2f714440527ff64ab0be03d0786c"
    sha256 cellar: :any_skip_relocation, catalina:      "1947a7acae8681b50278812ce9c61ca31330d9dd6fb02fd8a59405e86f67af68"
    sha256 cellar: :any_skip_relocation, mojave:        "6fd08826c214192439fe5589500292002de415280651cd1d13d5e29cd6121bd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d77a95946c3ee3008cc8424e9b4703a8d7a430cdde633defb5e27f860b235004"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    system bin/"procs", "--completion", "bash"
    system bin/"procs", "--completion", "fish"
    system bin/"procs", "--completion", "zsh"
    bash_completion.install "procs.bash" => "procs"
    fish_completion.install "procs.fish"
    zsh_completion.install "_procs"
  end

  test do
    output = shell_output(bin/"procs")
    count = output.lines.count
    assert count > 2
    assert output.start_with?(" PID:")
  end
end
