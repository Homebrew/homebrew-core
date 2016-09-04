class Cli53 < Formula
  desc "command-line tool for Amazon Route 53"
  homepage "https://github.com/barnybug/cli53"
  url "https://github.com/barnybug/cli53/archive/0.8.1.tar.gz"
  sha256 "941e8fc15842b27127db1a4aed215f30ecf97a031e05d68634b26af5dfa69cf9"

  bottle do
    cellar :any_skip_relocation
    sha256 "8178288a095dcc07a4ccbf6f29ac83ec12a11b1d3676fbbad9df023146990236" => :el_capitan
    sha256 "7afa7a539796a6bfce34a5ea0533f8c24692dd87d25325e72fbe638c70fef0e9" => :yosemite
    sha256 "42420cada089059146f414e3f7acd49d45a66fe30447992d031c5985ec6d2a84" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/barnybug"
    ln_s buildpath, buildpath/"src/github.com/barnybug/cli53"

    system "make", "build"
    bin.install "cli53"
  end

  test do
    assert_match "list domains", shell_output("#{bin}/cli53 help list")
  end
end
