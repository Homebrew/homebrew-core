class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v7.0.0.tar.gz"
  sha256 "93cc5a7c9199dc650f51a491e4ed4512262eeaeae5847722e6886763b41e2896"
  head "https://github.com/sharkdp/fd.git"

  bottle do
    sha256 "2644d73cbba8a1dd1520f6c2a2628c9c7417dbc58f39fac6936ae290dcea4774" => :high_sierra
    sha256 "e71f013de3825b3fe467304af14e50e3a3712b76628978628896b2ecdc6a5625" => :sierra
    sha256 "f5363d8f9a41dfbefe1368abb7baadf9d0cc5dc0294676af3ef531a9eced33a0" => :el_capitan
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
