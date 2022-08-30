class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.2.28.tar.gz"
  sha256 "1797322e144bd914473bbe915c5b10a5d4eecf12792a4692471178687fe64a1f"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38c5cd8c7a3edf3a8314a0a45820c0ab4687d84f11e7d0a9b32d5d756ff7bf06"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38c5cd8c7a3edf3a8314a0a45820c0ab4687d84f11e7d0a9b32d5d756ff7bf06"
    sha256 cellar: :any_skip_relocation, monterey:       "e43d1afd7455fd37e63248ee14123676baa845cb77c09cb72696413f139ad345"
    sha256 cellar: :any_skip_relocation, big_sur:        "e43d1afd7455fd37e63248ee14123676baa845cb77c09cb72696413f139ad345"
    sha256 cellar: :any_skip_relocation, catalina:       "e43d1afd7455fd37e63248ee14123676baa845cb77c09cb72696413f139ad345"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2ded2cdf9639005f2e832aed36d69f79b1a392239699e41084dd357a6c20cd8"
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
