class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v8.2.0.tar.gz"
  sha256 "fc024b48fa6e4ddde08ea9a9f01a76bd744ca43616795327ac69937655056b24"
  license "Apache-2.0"
  head "https://github.com/sharkdp/fd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b6de4654c70bbe24b85b0b580456a48d26c409482ea57702af09d640709ef762" => :big_sur
    sha256 "4625e56da438b94dfe331a2fe1df759b140931241af097df91f29d8ac314f2d3" => :catalina
    sha256 "d002e8d8de192b6fad189ff7830d4fe9fc7d4ca9e81aa5ac66bb5200c590703a" => :mojave
    sha256 "c269bbc76090614e7262c81e1b21d784050a71a51a5921686845f0d3c0855400" => :high_sierra
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
