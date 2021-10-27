class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v8.2.1.tar.gz"
  sha256 "429de7f04a41c5ee6579e07a251c72342cd9cf5b11e6355e861bb3fffa794157"
  license "Apache-2.0"
  head "https://github.com/sharkdp/fd.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91f363707c516476edb8feb37aa9001e044fce571929de9651f7a5bb66f46cb0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b50a503fc0bddc9c82d6ebc42198071160426ee6247c122f8fb81b1f9ecc4aeb"
    sha256 cellar: :any_skip_relocation, monterey:       "217a04685b72a167001a57a28dfb8270d4d625f90e4c8e9d62492dc616a9713e"
    sha256 cellar: :any_skip_relocation, big_sur:        "378bf3b71edf7c09a80cd8815bd068f6c2b8abaf2df149fc23f33f52acecc817"
    sha256 cellar: :any_skip_relocation, catalina:       "1fef32a7cd0c80f62343b4caf6a0979f89bacfa7434ed54ffede6adb85ace329"
    sha256 cellar: :any_skip_relocation, mojave:         "160cdfc22b5d0ac9694ce8dd95f7e22a7bdc95f6d376344d15f924f9ef67149b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d2387b3ee1027e1e6e06050edfd302d7dda1d13d3f4c646408ee57d968f07f5"
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
