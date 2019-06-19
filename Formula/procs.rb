class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.8.7.tar.gz"
  sha256 "3a3e21c811805c41943bca4ff79ffce233a21b7a48e88393d080d724abad764a"

  bottle do
    cellar :any_skip_relocation
    sha256 "306ce0be6a15009daf4e4a0d50a6487f32b058c53eb59a08b829d2aef21a89e5" => :mojave
    sha256 "4e8de209b3cb2606cef8a374dabf75be7d9df05502e9fab813e3f0d02458caaf" => :high_sierra
    sha256 "6f359aa56c8d443d16de94b2b6da932aa336a645cb1eb9b12cd9d04d48cb8c80" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/procs")
    count = output.lines.count
    assert count > 2
    assert output.start_with?(" PID:")
  end
end
