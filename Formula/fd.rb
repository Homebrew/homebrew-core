class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v6.1.0.tar.gz"
  sha256 "48b63d8c45345a2e677d14aa24157db05eed579a92b8d5a5406936f91351341f"
  head "https://github.com/sharkdp/fd.git"

  bottle do
    sha256 "9ecb04df32be60056733b82a7e0ffc7953050ca044de5df4be6fa12569f488ed" => :high_sierra
    sha256 "4dddac9285a39b5c6ba749ba4a0dd66f2182d39d4f4d5982a78bb0e0a42c1a9f" => :sierra
    sha256 "517c339c04871addb10deeb3de1e8dcf1733befb4b580e57ebbf9cfd97fd6686" => :el_capitan
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
