class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/releases/download/v2.59.0/docfx.zip"
  sha256 "e6bd6d788ddb07d9bcb6d90f2822d7e2e6c4feb0e2caeabc60ff39232d07bc52"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "202f8f1240d24d16474e82acb39561fffd761a889f0b06078f4763a957b3f958"
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
