class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.2.24.tar.gz"
  sha256 "29bbd279192cf79701f82cc468c4bde475362fb2d3749d605ddecd155780ddda"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ed37f2dd8412440e7b460e92e629a7e860c4e2ce8b40b4f0fca34f0e2b05753"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ed37f2dd8412440e7b460e92e629a7e860c4e2ce8b40b4f0fca34f0e2b05753"
    sha256 cellar: :any_skip_relocation, monterey:       "caa5d44555fad4046fe925a9bdf9c8c9a8217733dee4b2748ad751bcac979f2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "caa5d44555fad4046fe925a9bdf9c8c9a8217733dee4b2748ad751bcac979f2c"
    sha256 cellar: :any_skip_relocation, catalina:       "caa5d44555fad4046fe925a9bdf9c8c9a8217733dee4b2748ad751bcac979f2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a8ea7ef73c56800f20ed439507dd985ca6b8c71107792f3c48ae7de769918b8"
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
