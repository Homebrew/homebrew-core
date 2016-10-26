class Cli53 < Formula
  desc "command-line tool for Amazon Route 53"
  homepage "https://github.com/barnybug/cli53"
  url "https://github.com/barnybug/cli53/archive/0.8.6.tar.gz"
  sha256 "be1f97cf892c453410da69daa16141964d9fac6557447cadb0cb613ffe341c59"

  bottle do
    cellar :any_skip_relocation
    sha256 "28f0ffbda247d7d759e16f8b2acf15cb66255423cc0303ea0f889a596ab58b0c" => :sierra
    sha256 "b85c648d58c5e84874caa4fac645632398d9a18eccd4d9cf830b8a8b92689624" => :el_capitan
    sha256 "b8486f418e2eb29a5ad05018d55f4ba1c8745515a352e5429cd25810905b8fb3" => :yosemite
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
