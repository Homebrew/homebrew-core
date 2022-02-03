class CssCrush < Formula
  desc "Extensible PHP based CSS preprocessor"
  homepage "https://the-echoplex.net/csscrush"
  url "https://github.com/peteboere/css-crush/archive/v4.1.0.tar.gz"
  sha256 "08f80c38faed90dff38829841d532b36c548739cb90dec1b50b6b1009913f806"
  license "MIT"
  head "https://github.com/peteboere/css-crush.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b0f588a762d2dc621b5dbb577ee9b0cf85020ce85a5ab986a815724735f8027a"
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
