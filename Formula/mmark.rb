class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.2.16.tar.gz"
  sha256 "268b3da7ce77815f26785dbb95c244231452a9ca5de48bc0a125bfcc0591aee0"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "68492b698df4367e4df47169b0eaa9b6525332d1370ac0584f5d4e44354568ba"
    sha256 cellar: :any_skip_relocation, big_sur:       "43a495c72b63b05ad45f72ceea9a740f123ad94ab21c277d20062e40189c75dd"
    sha256 cellar: :any_skip_relocation, catalina:      "43a495c72b63b05ad45f72ceea9a740f123ad94ab21c277d20062e40189c75dd"
    sha256 cellar: :any_skip_relocation, mojave:        "43a495c72b63b05ad45f72ceea9a740f123ad94ab21c277d20062e40189c75dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8faa5cfc2180bcb920e40378d19e18513c9a83d3d26e8560100ffb378ddaead"
  end

  depends_on "go" => :build

  resource "test" do
    url "https://raw.githubusercontent.com/mmarkdown/mmark/v2.2.10/rfc/2100.md"
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
