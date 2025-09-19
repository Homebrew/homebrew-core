class CssCrush < Formula
  desc "Extensible PHP based CSS preprocessor"
  homepage "https://the-echoplex.net/csscrush"
  url "https://github.com/peteboere/css-crush/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "4fde4e991fa64e97f28c796c2267e155bca9de963713cc20d93c1618fd5285b6"
  license "MIT"
  head "https://github.com/peteboere/css-crush.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "76b89826d8214ed32749b25d382cbfd780d61e56c9043c52695ef0458a403ee2"
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
