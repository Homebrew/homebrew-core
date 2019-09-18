class Diffr < Formula
  desc "LCS based diff highlighting tool to ease code review from your terminal"
  homepage "https://github.com/mookid/diffr"
  url "https://github.com/mookid/diffr/archive/v0.1.2.tar.gz"
  sha256 "76767fec7bcec1f86ed0c21c05ce4fee3ac41e00f2b88e91249102b02c0f7307"

  depends_on "rust" => :build
  depends_on "diffutils" => :test

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"a").write "foo"
    (testpath/"b").write "foo"
    _output, status =
      Open3.capture2("#{Formula["diffutils"].bin}/diff -u a b | #{bin}/diffr")
    status.exitstatus.zero?
  end
end
