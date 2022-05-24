class Naturaldocs < Formula
  desc "Extensible, multi-language documentation generator"
  homepage "https://www.naturaldocs.org/"
  url "https://downloads.sourceforge.net/project/naturaldocs/Stable%20Releases/2.2/Natural_Docs_2.2.zip"
  mirror "https://naturaldocs.org/download/natural_docs/2.2/Natural_Docs_2.2.zip"
  sha256 "2d0d13c3373f30668a1fc7b08b8f3680c49182df4597cfe868573347fdf0e8ba"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/Natural.?Docs[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    sha256 cellar: :any, all: "567b95832d650915a5e845129d79a4cfdc0f0cab20870fad118425fd048e69db"
  end

  depends_on "mono"

  def install
    rm_f "libNaturalDocs.Engine.SQLite.Mac32.so"
    libexec.install Dir["*"]
    (bin/"naturaldocs").write <<~EOS
      #!/bin/bash
      mono #{libexec}/NaturalDocs.exe "$@"
    EOS

    libexec.install_symlink etc/"naturaldocs" => "config"
  end

  test do
    system "#{bin}/naturaldocs", "-h"
  end
end
