class Gofish < Formula
  desc "Cross-platform systems package manager"
  homepage "https://gofi.sh"
  url "https://github.com/fishworks/gofish.git",
      tag:      "v0.13.0",
      revision: "91f78df903ebdd05fb5ad820a645f41754e32bca"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "db76c4f80f2bcc9de811fb78d24ef3352a18072720edd3ba8fd0c985fdc1a41a" => :catalina
    sha256 "c2571af53fe2460268ad217cfb20fdcf187d29a5106393949ca22b64cfc69c49" => :mojave
    sha256 "97f68fea6cc4d9e3f7fe5cb6256f7fe7d3558df6067106d17adc274728464635" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "bin/gofish"
  end

  def caveats
    <<~EOS
      To activate gofish, run:
        gofish init
    EOS
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/gofish version")
  end
end
