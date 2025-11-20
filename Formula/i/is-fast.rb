class IsFast < Formula
  desc "Check the internet as fast as possible"
  homepage "https://github.com/Magic-JD/is-fast"
  url "https://github.com/Magic-JD/is-fast/archive/refs/tags/v0.17.7.tar.gz"
  sha256 "031ac21094cb3b276c3b36eee114aec6b9dd978e91aa4fe2cd4f669c35002963"
  license "MIT"
  head "https://github.com/Magic-JD/is-fast.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "222a5e8329764fe07042ba3a7a7d6c02f168a932da59e829a37f20709edab3f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8186c54949d4db91cd6184200f49a970e0a25896e6c20581711f6e92ba46c27b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a6fbe0fa25cda5b61f2ee6b50d3a58f73349bc8f7651eb5779519cdcecb571f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4dd437e3796594de6ed7a2d20397d60d7383699878591f8944f623fbd3ce78f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7fcb634bc9c7f7c3254386cd009fffb36eee194b5e7c8b40715e2ec276331d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3affe02807579a81844243d7e73f60e8ade59d83b2b507c5c998267dad77f5c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "is-fast #{version}", shell_output("#{bin}/is-fast --version")

    (testpath/"test.html").write <<~HTML
      <!DOCTYPE html>
      <html>
        <head><title>Test HTML page</title></head>
        <body>
          <p>Hello Homebrew!</p>
        </body>
      </html>
    HTML

    assert_match "Hello Homebrew!", shell_output("#{bin}/is-fast --piped --file #{testpath}/test.html")
  end
end
