class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.2.30.tar.gz"
  sha256 "04c74baadb4c3cd4c32f9e488b4b4e048ddb1b32411429911c827c2817a9816f"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cdb15b9f7cb1fba55cccd36032edb017d9ef23d20d53d796b96216281f17e5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0cdb15b9f7cb1fba55cccd36032edb017d9ef23d20d53d796b96216281f17e5f"
    sha256 cellar: :any_skip_relocation, monterey:       "4a1975b84425301a4c08cb1a71dc83f4ea4b6dbee3954a4d79b84fad517d10fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a1975b84425301a4c08cb1a71dc83f4ea4b6dbee3954a4d79b84fad517d10fc"
    sha256 cellar: :any_skip_relocation, catalina:       "4a1975b84425301a4c08cb1a71dc83f4ea4b6dbee3954a4d79b84fad517d10fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59d6d0a37275771dde45bdb2f5ba5b89ad574b0eec359d2ebc1af0a840fc8333"
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
