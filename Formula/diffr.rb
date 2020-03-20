class Diffr < Formula
  desc "LCS based diff highlighting tool to ease code review from your terminal"
  homepage "https://github.com/mookid/diffr"
  url "https://github.com/mookid/diffr/archive/v0.1.4.tar.gz"
  sha256 "2613b57778df4466a20349ef10b9e022d0017b4aee9a47fb07e78779f444f8cb"

  bottle do
    cellar :any_skip_relocation
    sha256 "7e01bf74ad7621aabeb9b3aaeb24d8482bc50919537378c43484f8cc86a80ffb" => :catalina
    sha256 "3f491387e259786609728ae103154e3d04ba31756bd142f8a088b17530343a23" => :mojave
    sha256 "4a9dc80b940b8f312b116509cbb79810e7ea829187669b4cc2e13e26d2cc98c1" => :high_sierra
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
