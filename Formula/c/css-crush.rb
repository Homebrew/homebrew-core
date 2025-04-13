class CssCrush < Formula
  desc "Extensible PHP based CSS preprocessor"
  homepage "https://the-echoplex.net/csscrush"
  url "https://github.com/peteboere/css-crush/archive/refs/tags/v4.1.3.tar.gz"
  sha256 "3afb4f3992b0bbf0a4cc0a1a1cf9c6f40d14b0ee91094ddefbb4a53d650fa234"
  license "MIT"
  head "https://github.com/peteboere/css-crush.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "7dd6610bca95f68d00bd025c5d30bc83f6a36a1a7a88fc6a1e30a3162e37005c"
  end

  depends_on "php"

  def install
    libexec.install Dir["*"]
    (bin+"csscrush").write <<~SHELL
      #!/bin/sh
      php "#{libexec}/cli.php" "$@"
    SHELL
  end

  test do
    (testpath/"test.crush").write <<~EOS
      @define foo #123456;
      p { color: $(foo); }
    EOS

    assert_equal "p{color:#123456}", shell_output("#{bin}/csscrush #{testpath}/test.crush").strip
  end
end
