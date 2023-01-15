class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/archive/refs/tags/v2.60.0.tar.gz"
  sha256 "884a1808f2dc69e7ab281950548690303ece43aad73ce94cb33a7ae9e687c078"
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
