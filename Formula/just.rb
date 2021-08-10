class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/0.10.0.tar.gz"
  sha256 "e566c333771697d61c6257f61d85fe8ff0a5993e66f050b2d10e80bd99d5fac0"
  license "CC0-1.0"
  head "https://github.com/casey/just.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8efc5dbc67be4237ef77bd83820f6b38d348299899174b1a42b432128ea57ca3"
    sha256 cellar: :any_skip_relocation, big_sur:       "ba11becd200c62303d831f2dbe79f75230f34ec8725b059bb514f69b97937bf8"
    sha256 cellar: :any_skip_relocation, catalina:      "3f217c1a6cbfbeddf5e45d794244d1acc12aa7ddd9c961c3389096b7381c47d0"
    sha256 cellar: :any_skip_relocation, mojave:        "15d43706357660a24295ff81e400578f21a1b2fe978067e94411e236d18e7bba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e629d91e84b4ee76a110333fcb4926b99e94cbf3942748fd2df79c469e0b6f7b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "man/just.1"
    bash_completion.install "completions/just.bash" => "just"
    fish_completion.install "completions/just.fish"
    zsh_completion.install "completions/just.zsh" => "_just"
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin/"just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
