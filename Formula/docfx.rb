class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/releases/download/v2.58.1/docfx.zip"
  sha256 "94085d7ee874c786909ba23e0f436c4aeffa3f6057a39d2229e70bd1b5e710ba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2073fd8b2e32d42fc754f534610432a0175dded8b86cba1f5e7fdb3886b46b79"
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
