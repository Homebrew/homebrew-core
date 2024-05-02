class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "https://exercism.io/cli/"
  url "https://github.com/exercism/cli/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "65f960c23a2c423cd8dfa2d8fcc1a083c3d5bc483717c96b5c71d3549fbc0fb7"
  license "MIT"
  head "https://github.com/exercism/cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71fd2ad23ce16e61f15c54ae893c5f866d723cdaaeea613e534a2336ea98396c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "488712c6cc1c169bb777af0f5a0602de3de917d5005e26d299ff57f4270cca8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d1b99f215c6f1e52e9e537eb9b910cc48812bf307728c141c3947ac09148b61"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e36ee9c787145b224a88e078c0df565fa852149c4937d1532a600b07d4f8f64"
    sha256 cellar: :any_skip_relocation, ventura:        "6c5f4316692358a842220a2c765af04ead905a1582e8451b365807e761d2c944"
    sha256 cellar: :any_skip_relocation, monterey:       "8fa56a688a68220b5bd7d5a09fadade15cdf18ae526e3a84aefc305b4f1beb00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b5bcf182c91d2206926931d4df1199d0a7ee6594966eecd4f582f923045f339"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "exercism/main.go"

    bash_completion.install "shell/exercism_completion.bash"
    zsh_completion.install "shell/exercism_completion.zsh" => "_exercism"
    fish_completion.install "shell/exercism.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/exercism version")
  end
end
