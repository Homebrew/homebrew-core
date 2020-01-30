class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.9.5.tar.gz"
  sha256 "d77245acea18ef18308d164f06fa299ddc433bc13006c6d5a9239fee87a4ce21"

  bottle do
    cellar :any_skip_relocation
    sha256 "2282bf74fab14263e7ea8d3b3007090261c187de134b60bedee7e45ba5b1cda4" => :catalina
    sha256 "0558b721d47ca9c7be3cc3c99c14c2148356077dcf9b77ebc9444fafee4752da" => :mojave
    sha256 "9370520595b04a3170e95b43c23a0c3dd10ccae0a3a48a055b43f32a54aa578b" => :high_sierra
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
