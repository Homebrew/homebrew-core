class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.2.10.tar.gz"
  sha256 "1fc9d26b4c2910e72c7ee94c80d2fb1707aaae2d278204c68557ccd1802a2c08"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "0c8b1e5790cf95425c1b929177150c9fe9859146e14670fc0b2e80b3a6d67020" => :big_sur
    sha256 "5b3ad3d847d107bea295ae82ede2123ad3f7404bafd23be0ed13e89d2da147dd" => :arm64_big_sur
    sha256 "30e4ee4ae7c5c24cb7a0aa4380a9bb6c0757bd8ab501b5137beaf645c71c101f" => :catalina
    sha256 "e874bd258951d5df18a3b059007ada27d8e43be623077f2b11900cdbf37f0b7c" => :mojave
    sha256 "d48a18e114f676ff7f7676fce7ca7d4bf6c1dcce7c9949e9161348d536a4aec1" => :high_sierra
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
