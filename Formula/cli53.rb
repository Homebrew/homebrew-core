class Cli53 < Formula
  desc "Command-line tool for Amazon Route 53"
  homepage "https://github.com/barnybug/cli53"
  url "https://github.com/barnybug/cli53/archive/0.8.18.tar.gz"
  sha256 "aa9ee59a52fc45f426680da48f45a79f2ac8365c15d8d7beed83a8ed71a891e4"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "9f7f7b6f459a9d42e4f58bf32a618046e124e5544af3fece7a76e7e50005dbe4" => :big_sur
    sha256 "98cb37be5b6af7dd7cc216a93ad0c5fb000d4bac22762e9731832de6119a9f0c" => :arm64_big_sur
    sha256 "9bf273343ecbaadbae4b55c1bc48bc529d1e6ecfe651848db995f2cd70966756" => :catalina
    sha256 "6e3fff5c7242c391fa6a43d1a9cb79467b56149102624b60abc8008e46280199" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./cmd/cli53"
  end

  test do
    assert_match "list domains", shell_output("#{bin}/cli53 help list")
  end
end
