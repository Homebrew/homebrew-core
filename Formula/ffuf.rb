class Ffuf < Formula
  desc "Fast web fuzzer written in Go"
  homepage "https://github.com/ffuf/ffuf"
  url "https://github.com/ffuf/ffuf/archive/v1.0.tar.gz"
  sha256 "1ad8263a4330d7a7f4d32829c4c8519a87879b716819580adcd1ee83118ac1a6"

  bottle do
    cellar :any_skip_relocation
    sha256 "1996d2b36b78dba79b0ad59921ee9652884323878c6f6e9d4978c0674a3cd5fb" => :catalina
    sha256 "c43088744a86b48c2e3f2b11c872209fce85f618062097639b974447ba75d6a6" => :mojave
    sha256 "73b2149c5c9674a693c95189dfc7418976f621e0c50bda75c78191930b2d30b5" => :high_sierra
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
