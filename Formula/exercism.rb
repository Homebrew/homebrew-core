class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "https://exercism.io/cli/"
  url "https://github.com/exercism/cli/archive/v3.0.13.tar.gz"
  sha256 "ecc27f272792bc8909d14f11dd08f0d2e9bde4cc663b3769e00eab6e65328a9f"
  license "MIT"
  head "https://github.com/exercism/cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "2b67328f03633996542bda37f25a7cf84e74732445cb89e64d2e3ae1fdf07b9e" => :big_sur
    sha256 "b67c57c567b36681731de3a6fa14fcc163aba8d063432dc3fd4fe9866ba7dfb4" => :arm64_big_sur
    sha256 "9a4080f7e35f37dc4eb15e733692314cec32cba7e0f76e8f58eb99850f708cb1" => :catalina
    sha256 "7319920cfd6779984dfabbecdf3e15a37603f6bfbecfc1121bfa2a044fb8ed17" => :mojave
    sha256 "b094a8441575b02f312f04760589f94d9f2b1d76330c07a67f7d07a40ad561a9" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"exercism", "exercism/main.go"
    prefix.install_metafiles

    bash_completion.install "shell/exercism_completion.bash"
    zsh_completion.install "shell/exercism_completion.zsh" => "_exercism"
    fish_completion.install "shell/exercism.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/exercism version")
  end
end
