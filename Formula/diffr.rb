class Diffr < Formula
  desc "LCS based diff highlighting tool to ease code review from your terminal"
  homepage "https://github.com/mookid/diffr"
  url "https://github.com/mookid/diffr/archive/v0.1.2.tar.gz"
  sha256 "76767fec7bcec1f86ed0c21c05ce4fee3ac41e00f2b88e91249102b02c0f7307"

  bottle do
    cellar :any_skip_relocation
    sha256 "94d2b07cb13676cf79c9b03ee04c7f8a5052e1db5ae4362d9280ac9ab1684ed6" => :catalina
    sha256 "c70d4132b9691bc9262a25e6b1aab523098f72db5f92cdcebc7ea911c318b8bd" => :mojave
    sha256 "62be44ce31921a8ee60cf55bd4235a32a7f6d96de73d2062413db84bafa13b69" => :high_sierra
  end

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
