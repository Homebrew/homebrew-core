class Ffuf < Formula
  desc "Fast web fuzzer written in Go"
  homepage "https://github.com/ffuf/ffuf"
  url "https://github.com/ffuf/ffuf/archive/v1.0.2.tar.gz"
  sha256 "018e3aa92d27846eaf55b49a451b2517db1ad65d5d696116ade1fe8bda4535ba"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa49f4d4ecfdeea7175978aa738aa5447505c590171c9002a2abee72eae9a9f6" => :catalina
    sha256 "0029f7f2024bbc1e0702af2d3616f2a74dc0903bed53c4b0c50cfcec20c899bb" => :mojave
    sha256 "8c24d59bb3c7c9e8cdc4699c966f4a8a2affe5e88a5f96a7d08754261e6613e9" => :high_sierra
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
    assert_match %r{:: Progress: \[5\/5\].*Errors: 0 ::$}, output
  end
end
