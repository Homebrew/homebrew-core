class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v8.1.0.tar.gz"
  sha256 "a58f0d74533a6e79a955c961c7228c53abfa3ca56051713be2395e56ac7212ce"
  head "https://github.com/sharkdp/fd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb253550d38af811f2518a0ad228c1c33af46b2a54531a0a29de3e30695c486b" => :catalina
    sha256 "4afb7fb27cd4a5208fbd29d4acf79136f9976e6812c12bc549bc262704b4f9c7" => :mojave
    sha256 "33fcd931ccca38055ebee6b83f9a4d70d5667e43521d1ef19fa6eb9f7db206e3" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
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
