class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v8.2.1.tar.gz"
  sha256 "429de7f04a41c5ee6579e07a251c72342cd9cf5b11e6355e861bb3fffa794157"
  license "Apache-2.0"
  head "https://github.com/sharkdp/fd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd916cd328337487954f0a6c7f9bb7579a6782fe6b8d091862c43118a0bc0b8c" => :big_sur
    sha256 "c9f64d2af2fc4aac3660b830bd36fbe8feb5fecdc301d5678ee7e198465d19bf" => :catalina
    sha256 "ef711df1c71826542e05385d19a50178564403e96ba5e46438dcf8d5e45313c0" => :mojave
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
