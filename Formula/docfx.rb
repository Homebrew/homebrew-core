class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/releases/download/v2.59.2/docfx.zip"
  sha256 "6bc31be6beed3af49942df0d20b35c7c8abdb32113ee433e3decd5d307fd76c9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "280a36a298319b3eb2314f4dc2f1d5c80fde6e53b875bc61530b12d2ec76e02d"
  end

  depends_on "mono"

  def install
    libexec.install Dir["*"]

    (bin/"docfx").write <<~EOS
      #!/bin/bash
      mono #{libexec}/docfx.exe "$@"
    EOS
  end

  test do
    system bin/"docfx", "init", "-q"
    assert_predicate testpath/"docfx_project/docfx.json", :exist?,
                     "Failed to generate project"
  end
end
