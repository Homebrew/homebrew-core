class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/releases/download/v2.58.9/docfx.zip"
  sha256 "18e2277704b318d5c785681b69296aa072eca30ee5cab5b19de77ede830bbd3c"
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
