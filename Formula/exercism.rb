class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "https://cli.exercism.io/"
  url "https://github.com/exercism/cli/archive/v3.0.12.tar.gz"
  sha256 "cdafd383d866dca4bc96be002d5d25eeea4801d003456a0215e28a2fba5a0820"
  head "https://github.com/exercism/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b3ff5e69c47a59e474eb667b04161882a0a22e7473f432c68f940d7fa51d2720" => :mojave
    sha256 "a874ff0731e29ae3b1739468677c763ada9d6b5405faad5a23a323a49376a927" => :high_sierra
    sha256 "16a0d5649378792c5abba4e443b6f1f365465121667af6cd990de225d6e6725d" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    dir = buildpath/"src/github.com/exercism/cli"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-ldflags", "-s -w", "-o", bin/"exercism", "exercism/main.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/exercism version")
  end
end
