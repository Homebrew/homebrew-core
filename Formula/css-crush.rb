class CssCrush < Formula
  desc "Extensible PHP based CSS preprocessor"
  homepage "https://the-echoplex.net/csscrush"
  url "https://github.com/peteboere/css-crush/archive/v4.1.3.tar.gz"
  sha256 "3afb4f3992b0bbf0a4cc0a1a1cf9c6f40d14b0ee91094ddefbb4a53d650fa234"
  license "MIT"
  head "https://github.com/peteboere/css-crush.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0e5343e4d21ca9c92e093f6dd4ac91a622cd567d848fcd6edb3b380504f97cb6"
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
