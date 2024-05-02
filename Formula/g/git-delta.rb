class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/refs/tags/0.17.0.tar.gz"
  sha256 "1abd21587bcc1f2ef0cd342784ce990da9978bc345578e45506419e0952de714"
  license "MIT"
  head "https://github.com/dandavison/delta.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0857ee2533e5731a3ff70fbba14bedf6ee066de4b3954fcac2a5291e781a5776"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1fd816757a69671cda27b70e981d137465988d6abf672fad9d643ff175448589"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddd619480dbd050fee0293cdfa73d8bace0d1b7d851c34ed7d390c57bf8110d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "d4562d1713f211739bad31fa4f8560d5b3c3d7bd8f7a61a4743552b0c6e3f81b"
    sha256 cellar: :any_skip_relocation, ventura:        "3ae765b906ec45cef98611ebfb0421d0d64206d6dd7065c86bb14d16eb529b6a"
    sha256 cellar: :any_skip_relocation, monterey:       "3d9797138ddc479b9ed8a180c30bf350b88c08a551ea6a43d34870fe448c8978"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f55330791412a4933e7efa64dcfaaac315830d7e90f27c79e92f3c266c77688a"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  conflicts_with "delta", because: "both install a `delta` binary"

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "etc/completion/completion.bash" => "delta"
    fish_completion.install "etc/completion/completion.fish" => "delta.fish"
    zsh_completion.install "etc/completion/completion.zsh" => "_delta"
  end

  test do
    assert_match "delta #{version}", `#{bin}/delta --version`.chomp
  end
end
