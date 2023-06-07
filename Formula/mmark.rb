class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.2.32.tar.gz"
  sha256 "6eadd2f69219aa522b5d93630e7f20722ac0427b1be483a91878591c89b3397f"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b4f8e792dece2b8a70b298bf2ae82337e7e8ef95a7132c61ad3b6c8c819320e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b4f8e792dece2b8a70b298bf2ae82337e7e8ef95a7132c61ad3b6c8c819320e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b4f8e792dece2b8a70b298bf2ae82337e7e8ef95a7132c61ad3b6c8c819320e"
    sha256 cellar: :any_skip_relocation, ventura:        "a7af8b9df08b860dce33987d7a7d575969cae5e3352b2553830510fbe1465369"
    sha256 cellar: :any_skip_relocation, monterey:       "a7af8b9df08b860dce33987d7a7d575969cae5e3352b2553830510fbe1465369"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7af8b9df08b860dce33987d7a7d575969cae5e3352b2553830510fbe1465369"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c61e9c007f88b34dd5f6bc5a548380e10b3b15b7470711d9244d0b09e445c34"
  end

  depends_on "go" => :build

  resource "homebrew-test" do
    url "https://raw.githubusercontent.com/mmarkdown/mmark/v2.2.19/rfc/2100.md"
    sha256 "0e12576b4506addc5aa9589b459bcc02ed92b936ff58f87129385d661b400c41"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    man1.install "mmark.1"
  end

  test do
    resource("homebrew-test").stage do
      assert_match "The Naming of Hosts", shell_output("#{bin}/mmark -ast 2100.md")
    end
  end
end
