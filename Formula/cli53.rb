class Cli53 < Formula
  desc "Command-line tool for Amazon Route 53"
  homepage "https://github.com/barnybug/cli53"
  url "https://github.com/barnybug/cli53/archive/0.8.18.tar.gz"
  sha256 "aa9ee59a52fc45f426680da48f45a79f2ac8365c15d8d7beed83a8ed71a891e4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1285195c10242659d35858428692fd398a97c3031096f4cfeb4f7c94f5a1519"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98cb37be5b6af7dd7cc216a93ad0c5fb000d4bac22762e9731832de6119a9f0c"
    sha256 cellar: :any_skip_relocation, monterey:       "3223d389c2439c44e687de2c0d13b361261b85f7e3b1179d11d58a2a34efd1a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f7f7b6f459a9d42e4f58bf32a618046e124e5544af3fece7a76e7e50005dbe4"
    sha256 cellar: :any_skip_relocation, catalina:       "9bf273343ecbaadbae4b55c1bc48bc529d1e6ecfe651848db995f2cd70966756"
    sha256 cellar: :any_skip_relocation, mojave:         "6e3fff5c7242c391fa6a43d1a9cb79467b56149102624b60abc8008e46280199"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e13f318c88bcdddce88b597b5739bdc53178d56db94f18ebe022a49445083d02"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cli53"
  end

  test do
    assert_match "list domains", shell_output("#{bin}/cli53 help list")
  end
end
