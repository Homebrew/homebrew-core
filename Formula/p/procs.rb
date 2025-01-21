class Procs < Formula
  desc "Modern replacement for ps written in Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/refs/tags/v0.14.9.tar.gz"
  sha256 "361982bd88bc84c184433309664598fdfdf5f603331cb21ba1108be40357608c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13de074bfdb72fbce7baeb6cdb039402bf1ecd6be29f30bc71f72d398f275d6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d2a64627d3ba8707a943c5e3a14fba42d46489c1c184a75cf4269bb18381c87"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d7e955d8bfe004817735b9af2bf35c79e2e81952e7875b29b9968c4315fb5ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "a80af64f33840a9aed859b762c72a9518c7e2ce73811caf89e9cf95f44cdddd4"
    sha256 cellar: :any_skip_relocation, ventura:       "7a9813b6372a9db96e3e836fcbb2335e7ea9880727806f4de04ebe0af35148fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c55a1fcb9c1f0c7dfc0c67a7c21147bba3fd448f7c63b970b4674da059adc63"
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
    assert count > 2
    assert output.start_with?(" PID:")
  end
end
