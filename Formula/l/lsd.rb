class Lsd < Formula
  desc "Clone of ls with colorful output, file type icons, and more"
  homepage "https://github.com/lsd-rs/lsd"
  url "https://github.com/lsd-rs/lsd/archive/v1.0.0.tar.gz"
  sha256 "ab34e9c85bc77cfa42b43bfb54414200433a37419f3b1947d0e8cfbb4b7a6325"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "96842f513bc310991a5aed5d259fa2e3dcb28293c1f2582158fd2fc7825cebf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1fe94fff7fef86679f860d60d5e59559d9fb9c5ed95087e16f8016e343d8d8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9330a76224be3e560f26949615fc1b3651b2ec51537c52b2dcd4467c10db9646"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8bd47f830bc20dbe0be8fdd92268d85d0f6c9091aa3976666db33d0766832925"
    sha256 cellar: :any_skip_relocation, sonoma:         "d24adcf6a92bb3e034dcf2b0250c41e8f20b0c6638f9058271b33fe5b5a8ac03"
    sha256 cellar: :any_skip_relocation, ventura:        "4731d6e0e3797d7aea0a06042a19879bf75c216e74115e9a06ed5b5fecd0760d"
    sha256 cellar: :any_skip_relocation, monterey:       "98f336d3681119672ec7bdcf796d5467a5f3ab32b50bbd03b4c5285ce8f1095d"
    sha256 cellar: :any_skip_relocation, big_sur:        "3109494fd5ddeb57d7a553c5a1e36ecfede0ba6ed5e909d3456ff144af7a34e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d402f8a249cdda889a2df5b0f93e7b8002cdf4ebb52101f9235f09660d18a368"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args
    bash_completion.install "lsd.bash"
    fish_completion.install "lsd.fish"
    zsh_completion.install "_lsd"

    system "pandoc", "doc/lsd.md", "--standalone", "--to=man", "-o", "doc/lsd.1"
    man1.install "doc/lsd.1"
  end

  test do
    output = shell_output("#{bin}/lsd -l #{prefix}")
    assert_match "README.md", output
  end
end
