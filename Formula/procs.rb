class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.13.3.tar.gz"
  sha256 "aa93a588504dcc74df699d8a3bc2a27d3da94a772106a42d3d862a5fd17725c3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0002680a3f1ed8b773ccdaad6305e14c3c9ca7563f6118a1e3a10b24bcf31e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be1ed73314de635fcdf4cb4361e86b5bdf597058a717c6ae6558d5e69e0d5ae0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9068c46fe2f378479efc299bb36649f3c269d78dde5f7d907b9b9d56cf77f6a"
    sha256 cellar: :any_skip_relocation, ventura:        "539feb4794a76cedf29ab185c777d77617ec35e4a7aa485314217bf60f7e0098"
    sha256 cellar: :any_skip_relocation, monterey:       "c39c70e498bd5b88b33935fff5eed339f756951ea4d26c2c4b65dba0eecb76a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "16875429b6cffec8de519fe7b33f6279332f1a9b94ee0249a9765bc63f10c783"
    sha256 cellar: :any_skip_relocation, catalina:       "7ba04a5851c39fd04dd171ad9230f7b0b3faa1388f703e767fad15e825baf07b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b03cf50be16bd72f2fe75fa43bdd734b98f0d827b37c1cdee057a1167a5c32f"
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
