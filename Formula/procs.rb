class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.10.4.tar.gz"
  sha256 "14a9d250af655be7b23454b857291dc0b021be5b274b6ea754205e664afa1573"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "c56900f3f1a6a66a14fc30bd4957bb628a668d970640b7b6372833112ad8f57f" => :catalina
    sha256 "33a33dbedac7200f13e22253a450d66d784274eff7a94ba5f034ba0c79a66dad" => :mojave
    sha256 "427cd09af3e3d8990bb971a312daa1daa9bd63f0b64b56e13c5694bdcbfcc492" => :high_sierra
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
