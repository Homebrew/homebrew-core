class Ffuf < Formula
  desc "Fast web fuzzer written in Go"
  homepage "https://github.com/ffuf/ffuf"
  url "https://github.com/ffuf/ffuf/archive/v1.2.0.tar.gz"
  sha256 "c9e8572545464afb507ac0e6f13a39ed91f3d485725acf4ffbad006ce5c8b29c"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "d63307832b7f132187a64eb46a1ce06e4d4252d329908c28f16f799e818d3d9b" => :big_sur
    sha256 "c0cbda48742f87b1e74de249bc9b199126c5ad3b97e874cdc774d45e1ba36029" => :arm64_big_sur
    sha256 "8fc266926a435bcc1a285c85f3fe567e24e0a78dbb7bc6fd70ac3555389fc98e" => :catalina
    sha256 "fe1a2ddaed8adfbd0249367faa655f313d1dd472c046d02e4545213ab781d95a" => :mojave
    sha256 "502c691d471d3416b4b193e8a08c53c8a330f961ee48cf2f4dd887e7522c3e86" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
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
