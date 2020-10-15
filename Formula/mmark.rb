class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.2.9.tar.gz"
  sha256 "70f080363ab3590e02471a7a48d6efc976072374dcbccd09884667f2002993fb"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "b5dc55010bf2cff163a57870e80b0ae01ee5342900b4f0665ec9176e65da9194" => :catalina
    sha256 "3a2891793f8f1ae7e0f47a35817f7cf7d1cc70899e95f494245e090e0ec4cce7" => :mojave
    sha256 "cc5dfaf278e61d45ad564a53a0a280fe74659b73cf5a4740ea6924f30c0a6aeb" => :high_sierra
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
