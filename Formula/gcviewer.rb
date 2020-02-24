class Gcviewer < Formula
  desc "Java garbage collection visualization tool"
  homepage "https://github.com/chewiebug/GCViewer"
  url "https://downloads.sourceforge.net/project/gcviewer/gcviewer-1.35.jar"
  sha256 "35d359a0aae175871f8d554ef1097e7f175e9f455980f6d59659f0e8d54e93f2"
  revision 1

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
