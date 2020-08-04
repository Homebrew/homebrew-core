class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.2.8.tar.gz"
  sha256 "40b60dec408da6cc74844006ab3677b3e6218e1efbe9840ee4e96f9adc2e2564"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "d32daeffa0d39c6a035fffc346b76d43f4a5976c75d8c1860b57e2a6ea2a3919" => :catalina
    sha256 "a546cd07a4a8337a4371f91c1711b1c359760177e8f03a81f9e501864efc0a17" => :mojave
    sha256 "a546cd07a4a8337a4371f91c1711b1c359760177e8f03a81f9e501864efc0a17" => :high_sierra
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
