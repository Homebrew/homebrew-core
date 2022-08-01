class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/1.3.0.tar.gz"
  sha256 "0214a95b7a46c6a812d3257a976114a6971892bc2129ebc87ee3094a329d71e6"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df2cf86c253f460bfd8946b308e7b55fbf543e9b794b329c28bfda75258f35f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4101ad9fbeb30cf08e47c97ef125254fc95a6dbc6f67d331eae37d5adfe20438"
    sha256 cellar: :any_skip_relocation, monterey:       "a9e7d7744d50642800d30fd71bd1186969afa62c7bbb1acab00449f2e7d8d51c"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f2cdddfff055157be9642a70d0d3feee46ce378019e50cd4d00bdc0b01e8fa7"
    sha256 cellar: :any_skip_relocation, catalina:       "8db7da8d57c737df68d636c10fb92c4e9134057ff74e381f33cd3995fc0df2e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b964ce56de96ac15559c5fa7b6bf58df83fe5972bc1b54c1519b436b72a3018"
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
