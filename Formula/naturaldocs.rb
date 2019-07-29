class Naturaldocs < Formula
  desc "Extensible, multi-language documentation generator"
  homepage "https://www.naturaldocs.org/"
  url "https://downloads.sourceforge.net/project/naturaldocs/Stable%20Releases/2.0.2/Natural_Docs_2.0.2.zip"
  sha256 "4a8be89d1c749fa40611193404556d408f414e03df8c397b970e045b57a54d4d"

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
