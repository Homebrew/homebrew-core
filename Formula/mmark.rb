class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.2.24.tar.gz"
  sha256 "29bbd279192cf79701f82cc468c4bde475362fb2d3749d605ddecd155780ddda"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43fd194822c30d78cbee92170c3e0b9739973c37358bf59a9615e997cdc10f9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43fd194822c30d78cbee92170c3e0b9739973c37358bf59a9615e997cdc10f9d"
    sha256 cellar: :any_skip_relocation, monterey:       "6e092a6947381abd978eabce25faf177b4a3c383372282b9fe84ede67afbfe69"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e092a6947381abd978eabce25faf177b4a3c383372282b9fe84ede67afbfe69"
    sha256 cellar: :any_skip_relocation, catalina:       "6e092a6947381abd978eabce25faf177b4a3c383372282b9fe84ede67afbfe69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba3c4a7beff6753a4bca281105d0b493af979e8ec998d04725474c4e9849f97c"
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
