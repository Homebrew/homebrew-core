class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/refs/tags/v2.2.45.tar.gz"
  sha256 "fb3e20117f11805de5459c78a56476a4b38877d03be49c1c1227598d80e01dfd"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a55606896295f39f74fde07fafeaf310b14a13523127260c33a465cf33152666"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f81aafdcf1415a6935341dd178be6e78571a93d64be0b12e7adaed3e9d01be7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f81aafdcf1415a6935341dd178be6e78571a93d64be0b12e7adaed3e9d01be7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f81aafdcf1415a6935341dd178be6e78571a93d64be0b12e7adaed3e9d01be7a"
    sha256 cellar: :any_skip_relocation, sonoma:         "078e9b2d78e98db52d99fecd58444ecbae75a4fd788660c225d41e3dfdae7a11"
    sha256 cellar: :any_skip_relocation, ventura:        "078e9b2d78e98db52d99fecd58444ecbae75a4fd788660c225d41e3dfdae7a11"
    sha256 cellar: :any_skip_relocation, monterey:       "078e9b2d78e98db52d99fecd58444ecbae75a4fd788660c225d41e3dfdae7a11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a452327a6728c523b8a944d737a10d7123e52a1735ed76990a05f7f6f5adff4"
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
