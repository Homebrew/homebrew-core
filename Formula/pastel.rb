class Pastel < Formula
  desc "Command-line tool to generate, analyze, convert and manipulate colors"
  homepage "https://github.com/sharkdp/pastel"
  url "https://github.com/sharkdp/pastel/archive/v0.8.0.tar.gz"
  sha256 "603dc63d6aa261f159178dffeb389471a845c1a5d62187a275a3d33a66fe9a69"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "fdae83eea8c1c098ddc551cbd18f010683b266fbffb111a93f3812709f581403" => :big_sur
    sha256 "5063fbbdfeae431e7522f8a66d48999e5ef0dc3d7dae922ffc088a227b90e1c4" => :arm64_big_sur
    sha256 "e2478748ed0561c76af8f68b4067f42cd365ad7735a9d44dda159e9bd35a1c1d" => :catalina
    sha256 "3d9fcb9c4f2e70010681b88f0ceca5795773b849e7bc6f59689e90ad969a673c" => :mojave
    sha256 "06f87da95e1d1b0f53fbcd9c9ff36e4c8a0d3ea85825ac7bc648b3ab445e61ee" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath/"completions"

    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/pastel.bash"
    zsh_completion.install "completions/_pastel"
    fish_completion.install "completions/pastel.fish"
  end

  test do
    output = shell_output("#{bin}/pastel format hex rebeccapurple").strip

    assert_equal "#663399", output
  end
end
