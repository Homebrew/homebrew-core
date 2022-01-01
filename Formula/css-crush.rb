class CssCrush < Formula
  desc "Extensible PHP based CSS preprocessor"
  homepage "https://the-echoplex.net/csscrush"
  url "https://github.com/peteboere/css-crush/archive/v4.0.0.tar.gz"
  sha256 "cef1c5c6af47abdc484e90c09486e316429143fb6a3ad109cf7d80c016350af1"
  license "MIT"
  head "https://github.com/peteboere/css-crush.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "06eec82e0757d06c7780b1695c31946d52e02e17af3566434023ac8262ddc28b"
  end

  depends_on "php"

  def install
    libexec.install Dir["*"]
    (bin+"csscrush").write <<~EOS
      #!/bin/sh
      php "#{libexec}/cli.php" "$@"
    EOS
  end

  test do
    (testpath/"test.crush").write <<~EOS
      @define foo #123456;
      p { color: $(foo); }
    EOS

    assert_equal "p{color:#123456}", shell_output("#{bin}/csscrush #{testpath}/test.crush").strip
  end
end
