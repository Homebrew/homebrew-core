class GitGrab < Formula
  desc "Git subcommand the organizes git repos while cloning."
  homepage "https://github.com/jmcgarr/git-grab"
  url "https://github.com/jmcgarr/git-grab/archive/0.2.tar.gz"
  version "0.2.0"
  sha256 "3452bba14cb4625da2da5ee6d08061356e647309cea149787b7aaaaf1db25406"

  head "https://github.com/jmcgarr/git-grab.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    # Install Go dependencies
    system "go", "get", "github.com/op/go-logging"

    # Build and install git-grab
    system "go", "build", "-o", "git-grab"
    bin.install "git-grab"
  end

  test do
    system "git", "grab"
  end
end
