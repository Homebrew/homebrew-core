class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.2.4.tar.gz"
  sha256 "71155187f2d3c9257a48d01c51ffafc9f6efa30d2225e1c8ca1670c42e384d69"

  bottle do
    cellar :any_skip_relocation
    sha256 "d83da93cb940640a7c129f363484f7dc141530f011c84b4404fa3a1575e4b164" => :catalina
    sha256 "d83da93cb940640a7c129f363484f7dc141530f011c84b4404fa3a1575e4b164" => :mojave
    sha256 "d83da93cb940640a7c129f363484f7dc141530f011c84b4404fa3a1575e4b164" => :high_sierra
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
