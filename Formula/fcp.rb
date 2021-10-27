class Fcp < Formula
  desc "Significantly faster alternative to the classic Unix cp(1) command"
  homepage "https://github.com/Svetlitski/fcp/"
  url "https://github.com/Svetlitski/fcp/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "e835d014849f5a3431a0798bcac02332915084bf4f4070fb1c6914b1865295f2"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd3f468c4a6ace4bf7b1eaa64711ef3fa72cfb87fc95e9df2cc3d41697c552d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2694de15f2cc9a32797a01cfde7f79a235a195fc65409582577a0c98977b1494"
    sha256 cellar: :any_skip_relocation, monterey:       "d3986aed8f7455ff3c0dbce337bc2ab5a984ab5bd31de75349a9589cc7d29d70"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e60b6a0d189ab71e4411a719ebdb2a7d8e15db7bc54c5a74ff47b2676a09cca"
    sha256 cellar: :any_skip_relocation, catalina:       "890ab9d94808f3b3534a9f2610f9502ac35a57ff827f9b12363ec9a5de52d50f"
    sha256 cellar: :any_skip_relocation, mojave:         "e54a5a79e09a561e2693dcef311856bfac90ae9221ebd30452d2812637fcea63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28c1e011bfdcb00954015a72ab6b8b24f2eeffb48ad95199fd169730e1235b28"
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
