class Ccheck < Formula
  desc "Check X509 certificate expiration from the command-line, with TAP output"
  homepage "https://github.com/nerdlem/ccheck"
  url "https://github.com/nerdlem/ccheck/archive/v1.0.1.tar.gz"
  sha256 "2325ea8476cce5111b8f848ca696409092b1d1d9c41bd46de7e3145374ed32cf"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eefb4874302348bbafd636ba38bc958b940c488a0acafc92357002d47e8fadf3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a31268fedbbe48cd989d6900c96b34b98e8354fe1e397dc96fb454a32376528e"
    sha256 cellar: :any_skip_relocation, monterey:       "f4784bc20e952229a571074101e28e68c82393c0ef224b141a0cecd93fa641b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "226e757f5a2253c0dacce3e97e6b325e9bb889c1ba775fb7cb38a9b797458b73"
    sha256 cellar: :any_skip_relocation, catalina:       "edc3a16f072eeca5647916de805bc80a753d00548b860a052f670b4698464632"
    sha256 cellar: :any_skip_relocation, mojave:         "4afea0fa685001ecf5777cb37975074cc382f2282bfe7fbaf9543c3b520272df"
    sha256 cellar: :any_skip_relocation, high_sierra:    "564171a220f9f031bd04044319b1e99e0a294208b3e804513ee0fe607525fe81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "441d2d833959bcf2908a40acf3677e974c2409719f2d353289431cb0bea40d04"
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
