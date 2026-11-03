class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-1.1.20.crate"
  sha256 "7329970a2a20bccbe07245b2f8e8aa8b00814319343e578379f886cc67feabb2"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cfc6f95d78c472427f4dd3651e1fb49799cac741c09efa223bf62c11519c06c0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "09e3f56c26ad79c4a22788466fcd6eca3ebfb354fe54f71e439aef0e8e9c9aa0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4ee293c4be22012ff3c56079d4c02e17766990ef11cafde4ebaa9c339f410c5d"
    sha256 cellar: :any,                 arm64_linux:       "8017c213984239bddfdec577512dcdd1998cafd309f801b80ea200d035cb92e8"
    sha256 cellar: :any,                 x86_64_linux:      "dd01094d1801364800bbf52a12cf7cf16ed814382a9ef46d2ef84090ab6f81ba"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", "--locked"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match(/Found \d+ model\(s\)/i, shell_output("#{bin}/llmfit search llama"))
  end
end
