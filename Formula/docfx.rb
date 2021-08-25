class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/releases/download/v2.58.2/docfx.zip"
  sha256 "1ca42ba47da7897eb3c7c38fd6a45283884b26a40e4af5c2d61b0f6b5a67dc1e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7eff301a5d1b559faa690c4fc616a0df774ce80251bafe1948732bb8ba6db54c"
  end

  depends_on arch: :x86_64
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
