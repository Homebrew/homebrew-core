class Ffuf < Formula
  desc "Fast web fuzzer written in Go"
  homepage "https://github.com/ffuf/ffuf"
  url "https://github.com/ffuf/ffuf/archive/v1.1.0.tar.gz"
  sha256 "468963c6bec5390222802ec0b04c11187bb159f369edc2ebba1d228b8faf4f35"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "8fc266926a435bcc1a285c85f3fe567e24e0a78dbb7bc6fd70ac3555389fc98e" => :catalina
    sha256 "fe1a2ddaed8adfbd0249367faa655f313d1dd472c046d02e4545213ab781d95a" => :mojave
    sha256 "502c691d471d3416b4b193e8a08c53c8a330f961ee48cf2f4dd887e7522c3e86" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"ffuf"
    prefix.install_metafiles
  end

  test do
    (testpath/"words.txt").write <<~EOS
      dog
      cat
      horse
      snake
      ape
    EOS

    output = shell_output("#{bin}/ffuf -u https://example.org/FUZZ -w words.txt 2>&1")
    assert_match %r{:: Progress: \[5/5\].*Errors: 0 ::$}, output
  end
end
