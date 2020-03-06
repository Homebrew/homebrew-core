class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.9.18.tar.gz"
  sha256 "b44db0b77c017afcbaeee917727abe3b82b3e479bdbc16111fe755dc0377c58d"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d950ff8da3d3dfd13802d66b0bf8ecce5b48839ca830de2276fd6960db89b8a" => :catalina
    sha256 "8ea1ebf2b73ab49565fe8bd1148cb33a1fcb122ade0c7bdc691ff9bbfd149c95" => :mojave
    sha256 "f4884b5dc9f4b0a56917e0cb07101bd431a28ff0e57eb1e0812db826241b93c9" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/procs")
    count = output.lines.count
    assert count > 2
    assert output.start_with?(" PID:")
  end
end
