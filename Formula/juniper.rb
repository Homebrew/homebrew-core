class Juniper < Formula
  desc "Functional Reactive Programming Language for the Arduino"
  homepage "http://www.juniper-lang.org/"
  url "http://www.juniper-lang.org/installers/Juniper-2.2.0.zip"
  sha256 "cb948faaa7a402387303807cada2385b61836f26b03d042f00bf92b66983ad86"

  bottle :unneeded

  depends_on "mono"

  def install
    libexec.install Dir["*"]
    (bin/"juniper").write <<~EOS
      #!/bin/bash
      mono #{libexec}/Juniper.exe "$@"
    EOS
  end

  test do
    system "#{bin}/juniper", "-h"
  end
end
