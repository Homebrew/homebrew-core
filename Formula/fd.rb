class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v6.2.0.tar.gz"
  sha256 "ca9c3995456fcb6f28aafea7d2b6c7ccddef1e98e3f4963aaee4d041ceba0a1d"
  head "https://github.com/sharkdp/fd.git"

  bottle do
    sha256 "90aaecafae4a84583dd28d6c990b2dd62b6863a7eb526c4238abf08da0f27390" => :high_sierra
    sha256 "ff2bab8446262eed78218a1347edabf4d174827755f4d2cc6d768f8f6b2f5810" => :sierra
    sha256 "f35f4f77b09a7c7050788b0d6185cb6355893b5952eaf362381c9c35e06b7169" => :el_capitan
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
