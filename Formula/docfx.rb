class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/releases/download/v2.23.1/docfx.zip"
  sha256 "9fdb2e8f050ce9dd8f17415c5c8bb81cea5403e1ac85f7941450dfbefe505104"

  bottle :unneeded

  depends_on "mono"

  def install
    libexec.install Dir["*"]

    (bin/"docfx").write <<-EOS.undent
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
