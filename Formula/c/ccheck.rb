class Ccheck < Formula
  desc "Check X509 certificate expiration from the command-line, with TAP output"
  homepage "https://github.com/nerdlem/ccheck"
  url "https://github.com/nerdlem/ccheck/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "2325ea8476cce5111b8f848ca696409092b1d1d9c41bd46de7e3145374ed32cf"
  license "GPL-2.0-or-later"
  head "https://github.com/nerdlem/ccheck.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "26489d1d45ade5e4462eaa3083558f872018bcd9d9e47b98e122f2dd086b402a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f0f8816e58c6387289a2ba6392a03b40c93f1f4e6fe840ff840b7550a476a7c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26ab4d218b0474e6c6d7ad9c11f89b17a7d98e846d5305972722edc87e5b0205"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44342aa8159dc8a960a1c59447e4de8a178cf1e6ed40baae0ebdd7fd3a58f194"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eefb4874302348bbafd636ba38bc958b940c488a0acafc92357002d47e8fadf3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a31268fedbbe48cd989d6900c96b34b98e8354fe1e397dc96fb454a32376528e"
    sha256 cellar: :any_skip_relocation, sonoma:         "7bcefa37758f67958aa0862ba81fd0593e451b4d0487e933320851156c0dde70"
    sha256 cellar: :any_skip_relocation, ventura:        "74350527eafdf458bb565391577cced252ce386c30bc03e8a3692fcb4198b933"
    sha256 cellar: :any_skip_relocation, monterey:       "f4784bc20e952229a571074101e28e68c82393c0ef224b141a0cecd93fa641b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "226e757f5a2253c0dacce3e97e6b325e9bb889c1ba775fb7cb38a9b797458b73"
    sha256 cellar: :any_skip_relocation, catalina:       "edc3a16f072eeca5647916de805bc80a753d00548b860a052f670b4698464632"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "02a98653ebd2b7dda5b82236bb39ca74772bf3d4ebce62a02e6039899d25f790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "441d2d833959bcf2908a40acf3677e974c2409719f2d353289431cb0bea40d04"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "brew-ccheck.libertad.link:443 TLS",
    shell_output("#{bin}/ccheck brew-ccheck.libertad.link:443").strip
  end
end
