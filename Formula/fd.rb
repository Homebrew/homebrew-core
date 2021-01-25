class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v8.2.1.tar.gz"
  sha256 "429de7f04a41c5ee6579e07a251c72342cd9cf5b11e6355e861bb3fffa794157"
  license "Apache-2.0"
  head "https://github.com/sharkdp/fd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "378bf3b71edf7c09a80cd8815bd068f6c2b8abaf2df149fc23f33f52acecc817" => :big_sur
    sha256 "b50a503fc0bddc9c82d6ebc42198071160426ee6247c122f8fb81b1f9ecc4aeb" => :arm64_big_sur
    sha256 "1fef32a7cd0c80f62343b4caf6a0979f89bacfa7434ed54ffede6adb85ace329" => :catalina
    sha256 "160cdfc22b5d0ac9694ce8dd95f7e22a7bdc95f6d376344d15f924f9ef67149b" => :mojave
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args
    man1.install "doc/fd.1"
    bash_completion.install "fd.bash"
    fish_completion.install "fd.fish"
    zsh_completion.install "contrib/completion/_fd"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "test_file", shell_output("#{bin}/fd test").chomp
  end
end
