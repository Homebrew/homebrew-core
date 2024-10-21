class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "https://exercism.io/cli/"
  url "https://github.com/exercism/cli/archive/refs/tags/v3.5.2.tar.gz"
  sha256 "0d259c5b6d9215fb7262172666393cd4345f221484f202a7821d940b8636dc90"
  license "MIT"
  head "https://github.com/exercism/cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "255b246439bc27ee2f35ebb1024567dadc81514b2049b515ddd465daf8039bf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "255b246439bc27ee2f35ebb1024567dadc81514b2049b515ddd465daf8039bf0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "255b246439bc27ee2f35ebb1024567dadc81514b2049b515ddd465daf8039bf0"
    sha256 cellar: :any_skip_relocation, sonoma:        "49f73f5baf24b05e63b20c4ecba444c866baacac380d08c0c43e86841e03607a"
    sha256 cellar: :any_skip_relocation, ventura:       "49f73f5baf24b05e63b20c4ecba444c866baacac380d08c0c43e86841e03607a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "132f5b5dca3c740b28c7edc67b10ba5ee7faa5c4cb222ae9049f80d27caab363"
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
