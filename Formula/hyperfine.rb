class Hyperfine < Formula
  desc "Command-line benchmarking tool"
  homepage "https://github.com/sharkdp/hyperfine"
  url "https://github.com/sharkdp/hyperfine/archive/v1.5.0.tar.gz"
  sha256 "d5183611348e696e579dda846cee92b7b78c8ef18c00bfb9b0a62d0a63034823"

  bottle do
    cellar :any_skip_relocation
    sha256 "a120be15174ce48b26ebd55204e218bb333e5375d826d930b9f5a9bfcd69f828" => :mojave
    sha256 "106336d918cc080a62b7217fb6e997aa37f1a4e626c5bb0d98c463d667d63ac9" => :high_sierra
    sha256 "c10178095d445c0db49b611d0ef6b7c83fbd18ef15c8d0ef0bec8dd2104a4236" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/hyperfine 'sleep 0.3'")
    assert_match "Benchmark #1: sleep", output
  end
end
