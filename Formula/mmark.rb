class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.2.31.tar.gz"
  sha256 "6a45f6a39deb2982207890b8ca2951baa802e44f9158f71e1c35e0d8421877a5"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c930f4428dc023e80188f804a97f16883ac713cd65e981ec1b9f03e0d0e00e65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed78da8d8fdb99ef55af08b061fdafc80099e65cfcdd32ed5a89eabf9b678f1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7196d9d0ff6bac25bea487a68193b16615bb830b62eaf03b333e184e757eb814"
    sha256 cellar: :any_skip_relocation, ventura:        "de64980aaa9d356dddfe086720c22ca0c57ad4057e4d73564cdd892a97616a18"
    sha256 cellar: :any_skip_relocation, monterey:       "923fe87dc6c9fe5e4649fb6168ed658e6476bb361628d45881154a71325f630c"
    sha256 cellar: :any_skip_relocation, big_sur:        "93cb1e6a4bbb8835e821759229144c7839f8ca7f12d3283ac77b979d1624ee2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdecdde0409f602e8d061f736015eb62652fe1484c45a403188921e61f6bbe01"
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
