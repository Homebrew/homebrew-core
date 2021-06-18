class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/releases/download/v2.58/docfx.zip"
  sha256 "a6ad1b9983debae0613816d83f31211d7bad0aaaef947cb25fef888294c48ebe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5dc40fb94b51e7761185ce0e078120877d94286282147100373b89484aac7241"
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
