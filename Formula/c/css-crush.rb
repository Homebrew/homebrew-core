class CssCrush < Formula
  desc "Extensible PHP based CSS preprocessor"
  homepage "https://the-echoplex.net/csscrush"
  url "https://github.com/peteboere/css-crush/archive/refs/tags/v5.0.1.tar.gz"
  sha256 "98b93ae9acb1586a1bdefeb377065206f62cb5f00f3ac065b65dff9dc5d0a979"
  license "MIT"
  head "https://github.com/peteboere/css-crush.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "85d7cf94858273e35f58f6d87bf6b8d62c0fa9b595bda0b716bd684f60c538f3"
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
