class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v7.4.0.tar.gz"
  sha256 "33570ba65e7f8b438746cb92bb9bc4a6030b482a0d50db37c830c4e315877537"
  head "https://github.com/sharkdp/fd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f20d5cb883fcf5796f96429376f3251a51b6bb522070be8ebb514f4b6a462713" => :mojave
    sha256 "fe9e33ff09a46fe7f3e7f25852be70de163c7ebdf9213533bf0bb0c1876bd744" => :high_sierra
    sha256 "4cc2785a526d2a377f2a32d675f5b3b0816044fe16a53cde55703cd610fccbef" => :sierra
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", "--root", prefix, "--path", "."
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
