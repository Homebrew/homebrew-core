class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.2.25.tar.gz"
  sha256 "dfc74c62cbb3c32ae1895ea8f067829752ece09e91c157811c699a840e6b2b94"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6732e33e22a4742ec79d3eadd20f1ed7c9f3f1fe1859b1a643b36e767604568"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6732e33e22a4742ec79d3eadd20f1ed7c9f3f1fe1859b1a643b36e767604568"
    sha256 cellar: :any_skip_relocation, monterey:       "10e4b1f687f9c457adcbc4121dc2cc79b2b2ecdf9a4940d166f0b2f2c9f86931"
    sha256 cellar: :any_skip_relocation, big_sur:        "10e4b1f687f9c457adcbc4121dc2cc79b2b2ecdf9a4940d166f0b2f2c9f86931"
    sha256 cellar: :any_skip_relocation, catalina:       "10e4b1f687f9c457adcbc4121dc2cc79b2b2ecdf9a4940d166f0b2f2c9f86931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43cdcdedf7a5a50741ea25e234fda6f9125864ea99d7a6c0ffeaaadec212bcf0"
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
