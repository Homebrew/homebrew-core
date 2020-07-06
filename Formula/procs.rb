class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.10.3.tar.gz"
  sha256 "cbb31a3a94b0c697aeb687f103c9128b3fed006cd0c802fb47f5c67415c32181"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4d64cc107a0b3c5a897655778eb3a1b10a30e2ed065c57c8f7e566ad75eccfb" => :catalina
    sha256 "4885c058e98ae2a7a7bca686fb6ba1b9a14e760b4bcf4bd4aace931088b382a8" => :mojave
    sha256 "88010001010a5d2b4e30a5e3adf5ba4e75e72d4ccb7bf8da78c326e09e928d4f" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/procs")
    count = output.lines.count
    assert count > 2
    assert output.start_with?(" PID:")
  end
end
