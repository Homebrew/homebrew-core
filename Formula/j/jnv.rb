class Jnv < Formula
  desc "Interactive JSON filter using jq"
  homepage "https://github.com/ynqa/jnv"
  url "https://github.com/ynqa/jnv/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "71bbd015f4594ef9723ea05a3325e2e8f8bf1f7d3c0309efa679826237ea8c9a"
  license "MIT"
  head "https://github.com/ynqa/jnv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc62615da88cce4421f44b01fa04d18848353b70de05655ae54f006bc2e2f790"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22b596715fd8f0c2ca7b86a5755aa9daf6d588271ca1aff3c7be2c26e5f2c449"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a10dddd869037b345c00873bae108311e2a6cb9a24cb600e714681515a561c8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "be8f48590ec358a076e2a3f7aa67c3612deecb9de92141e1145f8fde7dcbcbbc"
    sha256 cellar: :any_skip_relocation, ventura:       "ec608e3ee80ba96f64bcf9ff2026381af4124189a6ef66308fd5b8af4eee265b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3f1559c549efa79701fa2d43d0699b655367ac716081064a07afd31ed859fcf"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output(bin/"jnv --version")

    output = pipe_output("#{bin}/jnv 2>&1", "homebrew", 1)
    assert_match "Error: expected value at line 1 column 1", output
  end
end
