class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.2.2.tar.gz"
  sha256 "2521d600191a433cd001f3a82f0694b4951ef2c666ed9f250d358cf914ec98b1"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc624892ce13e3e70ff5fb726a55067680c9854ade0e73aa8133cd254f891ecf" => :catalina
    sha256 "bc624892ce13e3e70ff5fb726a55067680c9854ade0e73aa8133cd254f891ecf" => :mojave
    sha256 "bc624892ce13e3e70ff5fb726a55067680c9854ade0e73aa8133cd254f891ecf" => :high_sierra
  end

  depends_on "go" => :build

  resource "test" do
    url "https://raw.githubusercontent.com/mmarkdown/mmark/master/rfc/2100.md"
    sha256 "0b5383917a0fbc0d2a4ef009d6ccd787444ce2e80c1ea06088cb96269ecf11f0"
  end

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"mmark"
    man1.install "mmark.1"
    prefix.install_metafiles
  end

  test do
    resource("test").stage do
      assert_match "The Naming of Hosts", shell_output("#{bin}/mmark -ast 2100.md")
    end
  end
end
