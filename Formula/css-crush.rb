class CssCrush < Formula
  desc "Extensible PHP based CSS preprocessor"
  homepage "https://the-echoplex.net/csscrush"
  url "https://github.com/peteboere/css-crush/archive/v3.0.1.tar.gz"
  sha256 "6f24a857b496edccc2eaf261a6f34d64ae1dc2c288304df8dd4fcddb905d89d8"
  license "MIT"
  head "https://github.com/peteboere/css-crush.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "06eec82e0757d06c7780b1695c31946d52e02e17af3566434023ac8262ddc28b"
  end

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
