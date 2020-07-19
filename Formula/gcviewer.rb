class Gcviewer < Formula
  desc "Java garbage collection visualization tool"
  homepage "https://github.com/chewiebug/GCViewer"
  url "https://downloads.sourceforge.net/project/gcviewer/gcviewer-1.36.jar"
  sha256 "5e6757735903d1d3b8359ae8fabc66cdc2ac6646725e820a18e55b85b3bc00f4"
  license "LGPL-2.1"

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    (bin/"gcviewer").write <<~EOS
      #!/bin/bash
      exec "#{Formula["openjdk"].opt_bin}/java" -jar "#{libexec}/gcviewer-#{version}.jar" "$@"
    EOS
  end

  test do
    assert_predicate libexec/"gcviewer-#{version}.jar", :exist?
  end
end
