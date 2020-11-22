class Naturaldocs < Formula
  desc "Extensible, multi-language documentation generator"
  homepage "https://www.naturaldocs.org/"
  url "https://downloads.sourceforge.net/project/naturaldocs/Stable%20Releases/2.1/Natural_Docs_2.1.zip"
  mirror "https://naturaldocs.org/download/natural_docs/2.1/Natural_Docs_2.1.zip"
  sha256 "681a452ae6e981b0c0a0670d859873cceb3326939f2ae1e5f38bb27e91ac18c0"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/Natural.?Docs[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle :unneeded

  depends_on "mono"

  def install
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
