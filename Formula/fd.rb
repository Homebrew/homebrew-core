class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v7.1.0.tar.gz"
  sha256 "9385a55738947f69fd165781598de6c980398c6214a4927fce13a4f7f1e63d4d"
  head "https://github.com/sharkdp/fd.git"

  bottle do
    sha256 "be21df7d1288190659327d2dc4329989fa5700c15a50aef6049b7b54d6ac0602" => :high_sierra
    sha256 "b4098c7dfa787e8d44a617788f327b052b8c411ea30104fb20a841a84efe0ec8" => :sierra
    sha256 "829fddb0560b4b0ac2e198b05134508cfa13dc370ae7bd9c870172a6bd5c65e5" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", "--root", prefix
    man1.install "doc/fd.1"
    bash_completion.install "fd.bash"
    fish_completion.install "fd.fish"
    zsh_completion.install "_fd"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "test_file", shell_output("#{bin}/fd test").chomp
  end
end
