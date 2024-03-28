class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v13.0.1.tar.gz"
  sha256 "ccf1d6f35cca3f3d19d447f1bebede40c4f6c47c3d07512c5405067ee7379587"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "baa3615ef7992d01908d6c140655d4c1c697b6271b45844c07969a8757aedfea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49fbbbaf69f8f595fbd19c9ae2ec19041cf6548011f5c9b3118a58487bb17a45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4711422c4404e83a491d1e1b0af82a9eb9ea6e1ca74b218c0f1f7a1b27ee80e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "5db109cdcdb010c83a06eb3b36b40b8f4d0dbcc41e1b13f89e8809333796d933"
    sha256 cellar: :any_skip_relocation, ventura:        "196a2380d0c779101a32d2e0743fe21f634c9247079d603e1ae4d1e5d8aa410b"
    sha256 cellar: :any_skip_relocation, monterey:       "689dbfa6c1bad20b7edd436c2e231cd885ca056a15e8bcc6d57f669ad1b3679e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf631be744d0409b337b44f4da52339c5703f2535627e3bd823465d847aa7d59"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-town/git-town/v#{version.major}/src/cmd.version=v#{version}
      -X github.com/git-town/git-town/v#{version.major}/src/cmd.buildDate=#{time.strftime("%Y/%m/%d")}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin/"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-town -V")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin/"git-town", "config"
  end
end
