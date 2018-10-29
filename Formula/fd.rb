class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v7.2.0.tar.gz"
  sha256 "153d0ac821901d9843b501dd6ba00e82aa73e3d61c27b2150af7ebc1fb6dff67"
  head "https://github.com/sharkdp/fd.git"

  bottle do
    sha256 "0c4e3e81448c0c1fe41d3ee84c7f0fd28f2fb0a57888107b400be99032d3123c" => :mojave
    sha256 "42c3bf9ff769177c0ae456008a0b9f80c8a8851189838e3a0b74efa84d0b34db" => :high_sierra
    sha256 "4fe626ac8a1968b05a6d85789401589040c8170916e1b8f3a70475b3473efc5b" => :sierra
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
