class Fcp < Formula
  desc "Significantly faster alternative to the classic Unix cp(1) command"
  homepage "https://github.com/Svetlitski/fcp/"
  url "https://github.com/Svetlitski/fcp/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "c8c3da588711b1684370009e9a186232fe3c6c0db7ceff00b0ce0dacb98b9403"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "726a6e02c898303b23176423dea7a525bd4146fefdf544ed7f8f4e3a4ed1e133"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9cd7cac8e1836e0bcd97890b29c61a6c4121a8e1ae29f653a535da53996319e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b2256850c5d557b19ea7e27b0cb1fb62b1b011eb2e3605eae0b61f68bb835380"
    sha256 cellar: :any,                 arm64_linux:       "b5329a998ce87196e31d753a92c9df02e2f838c717a205a77c5fca449b41325b"
    sha256 cellar: :any,                 x86_64_linux:      "8f769ddab1abbc3a21c4d2cb11ee200b0d9fc4468464ca23f1b7b2bb848cac4b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"src.old").write "Hello world!"
    system bin/"fcp", "src.old", "dest.txt"
    assert_equal (testpath/"src.old").read, (testpath/"dest.txt").read

    (testpath/"src.new").write "Hello Homebrew!"
    system bin/"fcp", "src.new", "dest.txt"
    assert_equal (testpath/"src.new").read, (testpath/"dest.txt").read

    ["foo", "bar", "baz"].each { |f| (testpath/f).write f }
    (testpath/"dest_dir").mkdir
    system bin/"fcp", "foo", "bar", "baz", "dest_dir/"
    assert_equal (testpath/"foo").read, (testpath/"dest_dir/foo").read
    assert_equal (testpath/"bar").read, (testpath/"dest_dir/bar").read
    assert_equal (testpath/"baz").read, (testpath/"dest_dir/baz").read
  end
end
