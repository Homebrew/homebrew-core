class Dz6 < Formula
  desc "Fast Vim-inspired TUI hex editor"
  homepage "https://dz6.dev.br"
  url "https://github.com/mentebinaria/dz6/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "f995b1e8df20fca7bee48523e35e7bd9ec59f6df8066e342bbe8067176572887"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6714e44499788b1b780e0a0968cfaa5f4582e0f65d13d7ec969d941e0865c236"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "94906ff03e9935e65f160c04bdf4299fc778db974b750a0f978a9e67974fe0fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "babd7e0b19d8831e449289b532247bcba8f2f85f4fc8275410447f9ecaf14859"
    sha256 cellar: :any,                 arm64_linux:       "6a95b1ec0b347449ce97108adfb17d3318226f645d09a7aaf12ed6940dec9d59"
    sha256 cellar: :any,                 x86_64_linux:      "3d4b2086899936779a48b9e150dc8e7d1b8b0d93667d27d150d0de168eb6d8e7"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dz6 --version")
    output = shell_output("#{bin}/dz6 #{testpath/"missing.bin"} 2>&1", 1)
    assert_match "No such file or directory", output
  end
end
