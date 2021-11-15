class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.2.19.tar.gz"
  sha256 "1f24ef62fcdf3bbe36880aef4f8b5f4cc623884f399200987aa1b1be9a5a5326"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e7e69f2ab633743508dc330444b481d00188b25b14dc098765705cb49eb460a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e7e69f2ab633743508dc330444b481d00188b25b14dc098765705cb49eb460a"
    sha256 cellar: :any_skip_relocation, monterey:       "42e3b27a1e46d18d2aa838e7c5088563bcef713cd6805b83155114f88b1bb108"
    sha256 cellar: :any_skip_relocation, big_sur:        "42e3b27a1e46d18d2aa838e7c5088563bcef713cd6805b83155114f88b1bb108"
    sha256 cellar: :any_skip_relocation, catalina:       "42e3b27a1e46d18d2aa838e7c5088563bcef713cd6805b83155114f88b1bb108"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3e687f194f5fdc4301eeae40e54d428ec432cda34c6f939a66bcf6ef44a0159"
  end

  depends_on "go" => :build

  resource "test" do
    url "https://raw.githubusercontent.com/mmarkdown/mmark/v2.2.19/rfc/2100.md"
    sha256 "0e12576b4506addc5aa9589b459bcc02ed92b936ff58f87129385d661b400c41"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    man1.install "mmark.1"
  end

  test do
    resource("test").stage do
      assert_match "The Naming of Hosts", shell_output("#{bin}/mmark -ast 2100.md")
    end
  end
end
