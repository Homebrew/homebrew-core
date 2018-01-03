class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v6.2.0.tar.gz"
  sha256 "ca9c3995456fcb6f28aafea7d2b6c7ccddef1e98e3f4963aaee4d041ceba0a1d"
  head "https://github.com/sharkdp/fd.git"

  bottle do
    sha256 "d8771562cbde7d51c5a745f897b384abb9087dd68f999cffb2a10dc7dcaa0787" => :high_sierra
    sha256 "71c86d05bfaacec16a24422015b86fbea1c0fe208a223b61fa9563b3ae902826" => :sierra
    sha256 "b136dc7c318a598414b04e5814ca36a40b43105a2de82eed182849b42fb034e9" => :el_capitan
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
