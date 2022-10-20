class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/releases/download/v2.59.4/docfx.zip"
  sha256 "6de3058630cd89eeee8157d26a81d508a3ce5c0b64b0473c6360bf10a985a52b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "41c68c370d8e8599bdf37e345baa01988523b618fbc7c65718c4b78d7ed8b3d3"
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
