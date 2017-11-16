class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v6.0.0.tar.gz"
  sha256 "9d75a4962304d4430b87499d2ed14881c47ee6d5215d57d25371b594931745e3"
  head "https://github.com/sharkdp/fd.git"

  bottle do
    sha256 "bbb1501c7d891c056937a8ae0b670d0cf2fba972b92ac44e2fda3ae920b15ca6" => :high_sierra
    sha256 "d9f699b01a6e15e7943f0f1a3794c056a5b1647a90fc4911472874853e5098a5" => :sierra
    sha256 "b44e1a1edc935865e61e438cef25fa6b71f734674b505697811d60d13abfcaea" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", "--root", prefix
    man1.install "doc/fd.1"
    bash_completion.install "fd.bash-completion"
    fish_completion.install "fd.fish"
    zsh_completion.install "_fd"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "test_file", shell_output("#{bin}/fd test").chomp
  end
end
