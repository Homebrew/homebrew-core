class Cli53 < Formula
  desc "Command-line tool for Amazon Route 53"
  homepage "https://github.com/barnybug/cli53"
  url "https://github.com/barnybug/cli53/archive/0.8.11.tar.gz"
  sha256 "a3988a23faf8930672a8cf30fd1d655d908d9e66b84ece3ab79ef738f0dd94fe"

  bottle do
    cellar :any_skip_relocation
    sha256 "b0fc22663b72da1f70dc0aa814cad29b7b70b05d7d86b72389d0973eefbb45e5" => :high_sierra
    sha256 "51cb27467e305eb6cde457e13e8a698e10ce2828085653c7df50fe2d5310b499" => :sierra
    sha256 "c51377552bc5a6438dac6f0703ce97f6f027083a14936a9424baa7979382e05e" => :el_capitan
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
