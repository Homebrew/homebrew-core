class Naturaldocs < Formula
  desc "Extensible, multi-language documentation generator"
  homepage "https://www.naturaldocs.org/"
  url "https://downloads.sourceforge.net/project/naturaldocs/Stable%20Releases/2.3.1/Natural_Docs_2.3.1.zip"
  mirror "https://naturaldocs.org/download/natural_docs/2.3.1/Natural_Docs_2.3.1.zip"
  sha256 "92144e2deb1ff2606d29343cfea203ea890549ad2f77c03df1cea2d8014972cb"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/Natural.?Docs[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd5b8ae5f4eb425cfedd08ac4d23b5a5515851257576a0faf77592ba129c4d5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd5b8ae5f4eb425cfedd08ac4d23b5a5515851257576a0faf77592ba129c4d5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd5b8ae5f4eb425cfedd08ac4d23b5a5515851257576a0faf77592ba129c4d5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd5b8ae5f4eb425cfedd08ac4d23b5a5515851257576a0faf77592ba129c4d5c"
    sha256 cellar: :any_skip_relocation, ventura:       "cd5b8ae5f4eb425cfedd08ac4d23b5a5515851257576a0faf77592ba129c4d5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42c3c57a234e360a982c706672b29094dcd6cf848e4854e91c57f852f9d90ba3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42c3c57a234e360a982c706672b29094dcd6cf848e4854e91c57f852f9d90ba3"
  end

  depends_on "mono"

  def install
    os = OS.mac? ? "Mac" : "Linux"
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    libexec.install Dir["*"]
    (bin/"naturaldocs").write <<~BASH
      #!/bin/bash
      mono #{libexec}/NaturalDocs.exe "$@"
    BASH

    libexec.install_symlink etc/"naturaldocs" => "config"

    libexec.glob("libSQLite.*").each do |f|
      rm f if f.basename.to_s != "libSQLite.#{os}.#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output(bin/"naturaldocs -v")

    output = shell_output(bin/"naturaldocs --list-encodings")
    assert_match "Unicode (UTF-8)", output
  end
end
