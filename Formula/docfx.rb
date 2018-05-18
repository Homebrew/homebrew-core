class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/releases/download/v2.36/docfx.zip"
  sha256 "40bf1b425c56d5759f2acbe0a5cf350ebbfef3958545eb92491f7e37638fb0cc"

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
