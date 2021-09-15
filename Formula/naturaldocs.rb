class Naturaldocs < Formula
  desc "Extensible, multi-language documentation generator"
  homepage "https://www.naturaldocs.org/"
  url "https://downloads.sourceforge.net/project/naturaldocs/Stable%20Releases/2.1.1/Natural_Docs_2.1.1.zip"
  mirror "https://naturaldocs.org/download/natural_docs/2.1.1/Natural_Docs_2.1.1.zip"
  sha256 "00ebfee968c4b88ebd213d1e48be37686d717d938dfa6c739c23b769bdf03c1f"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/Natural.?Docs[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    sha256 cellar: :any, all: "b3f1bd9379493b6a369f464f0af31524da2c7182bfd5f5076c1384813da98c28"
  end

  depends_on arch: :x86_64 # mono does not have ARM support yet
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
