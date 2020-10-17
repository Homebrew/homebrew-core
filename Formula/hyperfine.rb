class Hyperfine < Formula
  desc "Command-line benchmarking tool"
  homepage "https://github.com/sharkdp/hyperfine"
  url "https://github.com/sharkdp/hyperfine/archive/v1.11.0.tar.gz"
  sha256 "740f4826f0933c693fb281e3542d312da9ccc8fd68cebe883359a8085ddd77e9"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "09e341141f121b5b0caf0b4a9552b79a0777f8076910b1c91a65c29483102b36" => :catalina
    sha256 "29051b59797e70714593561f09901ef02e9c79bc9b9b4b6ae226c53ca021f4ca" => :mojave
    sha256 "49ea032f8c1403e6ab23e0f451e9bdf2e16f6e581cbd84f94743243ced62910d" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args
    man1.install "doc/hyperfine.1"
    bash_completion.install "hyperfine.bash"
    fish_completion.install "hyperfine.fish"
    zsh_completion.install "_hyperfine"
  end

  test do
    output = shell_output("#{bin}/hyperfine 'sleep 0.3'")
    assert_match "Benchmark #1: sleep", output
  end
end
