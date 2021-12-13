class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.2.23.tar.gz"
  sha256 "8c4ebb780f86f17647de1d81532bf6900498ec48edcdf03de6ef6e68287ae510"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e2ea524d666c1a57c4dec7d7d602a3caffec699e179a6ccf7b4b65a6b354370"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e2ea524d666c1a57c4dec7d7d602a3caffec699e179a6ccf7b4b65a6b354370"
    sha256 cellar: :any_skip_relocation, monterey:       "03bda1fdeb96331179d20f72dcc8c8599625f66c7b3940c63651c64c077520e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "03bda1fdeb96331179d20f72dcc8c8599625f66c7b3940c63651c64c077520e2"
    sha256 cellar: :any_skip_relocation, catalina:       "03bda1fdeb96331179d20f72dcc8c8599625f66c7b3940c63651c64c077520e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1461c8471c218599ebb05196d50d02bdcedb04aa45243f9d1f65ffd885d1550"
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
