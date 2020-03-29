class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.2.5.tar.gz"
  sha256 "9fec3da78b75bf49d98885d178123617df7d516630a1255e54c9e9a7a41eb057"

  bottle do
    cellar :any_skip_relocation
    sha256 "35874a678154992f4c120de3a560d063935117ac1a8132c23efb91c5b8450cdd" => :catalina
    sha256 "35874a678154992f4c120de3a560d063935117ac1a8132c23efb91c5b8450cdd" => :mojave
    sha256 "35874a678154992f4c120de3a560d063935117ac1a8132c23efb91c5b8450cdd" => :high_sierra
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
