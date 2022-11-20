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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2581bfc5df020bbe4b83660fcf8c41d98f1bbadc4b2eeaa9d38e5d732706e1f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86e9ee14f358f313fd20742cbc3c499853973ae51801cbc2a05cb467e8564bdf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb23fde600b15782fbf8d35106510d6f7dd8fcf869fde6571b066b81bea90aca"
    sha256 cellar: :any_skip_relocation, ventura:        "0ab8468cb87e1b8e4c98492da40a211ba4afe8871a7dee9eb14899411515dcb2"
    sha256 cellar: :any_skip_relocation, monterey:       "c042caa2bd2172e276c0655553ce7009598ae0b34dfbe6c38641382b57a02eea"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6623580eb5027ceb5acbe4a77d90009b4e5f2a702dfe8088b85afd56562f3f3"
    sha256 cellar: :any_skip_relocation, catalina:       "626455ae555f987dfc0f6d43a49be3bfdba29873622b0662ca05fb8c13ad70af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73706dfe2bc62121136bb6ee95c3bb98f6ab584193078386abc23afc1e6f5ca6"
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
