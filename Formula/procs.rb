class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.10.8.tar.gz"
  sha256 "74255cca2b8599892bca30a5b88a6ff8fa30a79900859ea037d2f7ab3b5ac793"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "a930c262828b2bfef0a16166d2b310cc958af0fee2f97cd61d5b0f53b31debed" => :big_sur
    sha256 "d99de02a8ca920d0354b9dd25c7f11932cce9c8f7b8852e9a90c1d87a53782e7" => :catalina
    sha256 "f1d77baf604e57b25e5abea150ededf06acef7c9efdc552af2c1c2ff307d8b18" => :mojave
    sha256 "a0836dc38f18299c3f42d6485684d3868913b1bc00ba2d762cdf2a922aadc1aa" => :high_sierra
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
