class Procs < Formula
  desc "Modern replacement for ps written in Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/refs/tags/v0.14.11.tar.gz"
  sha256 "3d6b3561ce05362a092ea8488458f552d6636d3a280290e21f841c432cadf91a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fc0d22bae08da3b7bdd12a282b34ac7c1746de8121f932477b2ece2780b6604"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d2cef6e1289edfbc7aeaf1a5f26054a2a049253713472a8a03f16053d640957"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffee097ac82471af66147183678881e36416160c38c47688ed0b6093bb223ce6"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8edf9481f5bf456502a77fe6cc2a90d31158f8f5248ec3934753ff53a4c5fdc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef31fd9dc0ec5863476b50ab1d45a81972373638de7149466dd40f51d10944cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eac2601653fec00065e2f9b26f7020b172691d7be597ec6d9cbaf98be87a7642"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    system bin/"procs", "--gen-completion", "bash"
    system bin/"procs", "--gen-completion", "fish"
    system bin/"procs", "--gen-completion", "zsh"
    bash_completion.install "procs.bash" => "procs"
    fish_completion.install "procs.fish"
    zsh_completion.install "_procs"
  end

  test do
    output = shell_output(bin/"procs")
    count = output.lines.count
    assert_operator 2, :<, count
    assert_match(/^ PID:/, output)
  end
end
