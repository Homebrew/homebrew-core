class Naturaldocs < Formula
  desc "Extensible, multi-language documentation generator"
  homepage "https://www.naturaldocs.org/"
  url "https://downloads.sourceforge.net/project/naturaldocs/Stable%20Releases/2.3/Natural_Docs_2.3.zip"
  mirror "https://naturaldocs.org/download/natural_docs/2.3/Natural_Docs_2.3.zip"
  sha256 "37dcfeaa0aee2a3622adc85882edacfb911c2e713dba6592cbee6812deddd2f2"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/Natural.?Docs[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c8381f2df948395879acd6d145586b1f94f94cb99d5f7fb5a60560b2584934bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8381f2df948395879acd6d145586b1f94f94cb99d5f7fb5a60560b2584934bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8381f2df948395879acd6d145586b1f94f94cb99d5f7fb5a60560b2584934bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8381f2df948395879acd6d145586b1f94f94cb99d5f7fb5a60560b2584934bf"
    sha256 cellar: :any_skip_relocation, ventura:        "c8381f2df948395879acd6d145586b1f94f94cb99d5f7fb5a60560b2584934bf"
    sha256 cellar: :any_skip_relocation, monterey:       "c8381f2df948395879acd6d145586b1f94f94cb99d5f7fb5a60560b2584934bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c39b957abe3a6a51190a7ad008dc9bd8c7ef2014b8c03ff5f0b258c1293735e"
  end

  depends_on "mono"

  def install
    rm_f "libNaturalDocs.Engine.SQLite.Mac32.so"

    os = OS.mac? ? "Mac" : "Linux"
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    libexec.install Dir["*"]
    (bin/"naturaldocs").write <<~EOS
      #!/bin/bash
      mono #{libexec}/NaturalDocs.exe "$@"
    EOS

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
