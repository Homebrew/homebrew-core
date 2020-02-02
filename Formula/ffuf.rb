class Ffuf < Formula
  desc "Fast web fuzzer written in Go"
  homepage "https://github.com/ffuf/ffuf"
  url "https://github.com/ffuf/ffuf/archive/v1.0.1.tar.gz"
  sha256 "883289c304f69163f6be4c4d5d921f401e5fd260d9c580f0a8775062c44333a1"

  bottle do
    cellar :any_skip_relocation
    sha256 "a56a5568bdc1d29358ab134b6b15dc446f61f37c73c23c28146361e69dcb008b" => :catalina
    sha256 "067979a4307641df78dd99eeb8620efbaf0f12e0921f778956f789a26ebbcc4b" => :mojave
    sha256 "65d2865a483e1d0d0bda9c127927544b9930b32de76b7f23b22bda0e9a71904f" => :high_sierra
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
