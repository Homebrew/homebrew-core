class Ffuf < Formula
  desc "Fast web fuzzer written in Go"
  homepage "https://github.com/ffuf/ffuf"
  url "https://github.com/ffuf/ffuf/archive/v1.0.1.tar.gz"
  sha256 "883289c304f69163f6be4c4d5d921f401e5fd260d9c580f0a8775062c44333a1"

  bottle do
    cellar :any_skip_relocation
    sha256 "7da6328282eb13a189d20ae14a23333c919f4e4817881f8163955899c11d6c99" => :catalina
    sha256 "4f0521eff0be5b5df334e94729186706c557e6d9b6daf62cb8c0d11407a0d9b7" => :mojave
    sha256 "22c580ce9d27759319e00389451da9d5e72b100d5cd90762a5aa45dd8b878edd" => :high_sierra
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
