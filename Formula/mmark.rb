class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.2.27.tar.gz"
  sha256 "df7ff4d14c9540f55926527352db0db83585fd2f4a7489003e534121f68d14b6"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ebd340ad297a2a9e347afe4a577aa18c3c515aa8a57f903fab51c37e740a608"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ebd340ad297a2a9e347afe4a577aa18c3c515aa8a57f903fab51c37e740a608"
    sha256 cellar: :any_skip_relocation, monterey:       "afd6f0c8201d1c9237f903e07a7118a8b740d6e40eaa256718a43f0e083c1ac6"
    sha256 cellar: :any_skip_relocation, big_sur:        "afd6f0c8201d1c9237f903e07a7118a8b740d6e40eaa256718a43f0e083c1ac6"
    sha256 cellar: :any_skip_relocation, catalina:       "afd6f0c8201d1c9237f903e07a7118a8b740d6e40eaa256718a43f0e083c1ac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1559449434fabae5a755689f6085e3799975455d221e1c1265253c13edc6b016"
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
