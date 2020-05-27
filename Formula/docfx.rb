class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/releases/download/v2.53.1/docfx.zip"
  sha256 "24ac5968b2f1ea3f78aebd971c6229046eb8ebf20f70efa32acae386eb086696"

  bottle :unneeded

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
