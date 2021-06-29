class Fcp < Formula
  desc "Significantly faster alternative to the classic Unix cp(1) command"
  homepage "https://github.com/Svetlitski/fcp/"
  url "https://github.com/Svetlitski/fcp/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "7e4e69bdb7f1f831dc52cd517afdd5722313d3dece3afd7dad418d224d4badd1"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dead76c3970ca3234354847c718ccefb8b1ec6b5316e7b0dad386a907a531665"
    sha256 cellar: :any_skip_relocation, big_sur:       "a1ab4eee959861298d34c1d83b20bc5ed75013d28d5b35bedfd773b08e80c13c"
    sha256 cellar: :any_skip_relocation, catalina:      "89c5d3ff8c34dbbc6052b68b4eb1a58420d08e0fc6cb1b4ffbac60126ba85091"
    sha256 cellar: :any_skip_relocation, mojave:        "70db6ca6787f72fee1020d0c5c0b3a3070a6cd3c269ce6f4aecf5e9db6609114"
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
