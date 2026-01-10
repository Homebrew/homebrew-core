class Kroki < Formula
  desc "Create diagrams from textual descriptions"
  homepage "https://kroki.io"
  url "https://github.com/yuzutech/kroki-cli/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "f7b0fe1dd49eb5fe6d6cbc892e1e84d670d1a90f0c457c7c28e4201654da6c3e"
  license "MIT"
  head "https://github.com/yuzutech/kroki-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"kroki", "version"
  end
end
