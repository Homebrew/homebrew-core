class Ccheck < Formula
  desc "Check X509 certificate expiration from the command-line, with TAP output"
  homepage "https://github.com/nerdlem/ccheck"
  url "https://github.com/nerdlem/ccheck/archive/v1.0.1.tar.gz"
  sha256 "2325ea8476cce5111b8f848ca696409092b1d1d9c41bd46de7e3145374ed32cf"
  license "GPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "226e757f5a2253c0dacce3e97e6b325e9bb889c1ba775fb7cb38a9b797458b73" => :big_sur
    sha256 "a31268fedbbe48cd989d6900c96b34b98e8354fe1e397dc96fb454a32376528e" => :arm64_big_sur
    sha256 "edc3a16f072eeca5647916de805bc80a753d00548b860a052f670b4698464632" => :catalina
    sha256 "4afea0fa685001ecf5777cb37975074cc382f2282bfe7fbaf9543c3b520272df" => :mojave
    sha256 "564171a220f9f031bd04044319b1e99e0a294208b3e804513ee0fe607525fe81" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"ccheck", "main.go"
    prefix.install_metafiles
  end

  test do
    assert_equal "brew-ccheck.libertad.link:443 TLS",
    shell_output("#{bin}/ccheck brew-ccheck.libertad.link:443").strip
  end
end
