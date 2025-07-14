class CssCrush < Formula
  desc "Extensible PHP based CSS preprocessor"
  homepage "https://the-echoplex.net/csscrush"
  url "https://github.com/peteboere/css-crush/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "4c4a898ada8685cf7e33a1cdaca470ca45ec66ffbc441e749b2014f3010fd0aa"
  license "MIT"
  head "https://github.com/peteboere/css-crush.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "57dca95e7404936bc249a6934132a3942e31f4c1574e99dce5907c32bc14ad77"
  end

  depends_on "php"

  def install
    libexec.install Dir["*"]
    (bin/"csscrush").write <<~SHELL
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
