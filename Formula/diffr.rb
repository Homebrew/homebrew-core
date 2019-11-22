class Diffr < Formula
  desc "LCS based diff highlighting tool to ease code review from your terminal"
  homepage "https://github.com/mookid/diffr"
  url "https://github.com/mookid/diffr/archive/v0.1.2.tar.gz"
  sha256 "76767fec7bcec1f86ed0c21c05ce4fee3ac41e00f2b88e91249102b02c0f7307"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7bc3fdeb01f7f6acc385066847790d4fbecfc63aba6500875aaa0dd51fe34d28" => :catalina
    sha256 "4ff2b883f183c94c5ceb521f066dca3efff1fa5e11f07e0dbd119219eb84530c" => :mojave
    sha256 "2673e95643de656f2216f54ff37c83462927f192a9bab377f10b29e241618268" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "diffutils" => :test

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"a").write "foo"
    (testpath/"b").write "foo"
    _output, status =
      Open3.capture2("#{Formula["diffutils"].bin}/diff -u a b | #{bin}/diffr")
    status.exitstatus.zero?
  end
end
