class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.2.34.tar.gz"
  sha256 "0dd4152eb9fa95ee4f2766fb861a8d0a32884f634d8c843c420d0ed0c17f8eae"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e5ec0c717ad64ddbb3a7007ae59be2c623b16337ef679ba7ce60f8f3e644b9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e5ec0c717ad64ddbb3a7007ae59be2c623b16337ef679ba7ce60f8f3e644b9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e5ec0c717ad64ddbb3a7007ae59be2c623b16337ef679ba7ce60f8f3e644b9d"
    sha256 cellar: :any_skip_relocation, ventura:        "27ae27bb1e7bc68f33aa5abfc55ceb9e182daf62a27ab7e0277e93f61c1d40a0"
    sha256 cellar: :any_skip_relocation, monterey:       "27ae27bb1e7bc68f33aa5abfc55ceb9e182daf62a27ab7e0277e93f61c1d40a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "27ae27bb1e7bc68f33aa5abfc55ceb9e182daf62a27ab7e0277e93f61c1d40a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7db35301955acb7a136be34cc8b2e06cc0eb1775b29d127a52e82cb5b0e35c8a"
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
