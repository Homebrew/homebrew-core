class CssCrush < Formula
  desc "Extensible PHP based CSS preprocessor"
  homepage "https://the-echoplex.net/csscrush"
  url "https://github.com/peteboere/css-crush/archive/v4.1.2.tar.gz"
  sha256 "ebc6176c87299e14f7e19b4111db9bdfe4bbec8c4547927ab6d370011b839437"
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
