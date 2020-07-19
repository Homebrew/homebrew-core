class Fmpp < Formula
  desc "Text file preprocessing tool using FreeMarker templates"
  homepage "https://fmpp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/fmpp/fmpp/0.9.16/fmpp_0.9.16.tar.gz"
  sha256 "86561e3f3a2ccb436f5f3df88d79a7dad72549a33191901f49d12a38b53759cd"
  license "Apache-2.0"
  revision 1
  head "https://github.com/freemarker/fmpp.git"

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install "lib"
    (bin/"fmpp").write <<~EOS
      #!/bin/bash
      exec "#{Formula["openjdk"].opt_bin}/java" -Dfmpp.home="#{libexec}" $FMPP_OPTS $FMPP_ARGS -jar "#{libexec}/lib/fmpp.jar" "$@"
    EOS
  end

  test do
    (testpath/"input").write '<#assign foo="bar"/>${foo}'
    system bin/"fmpp", "input", "-o", "output"
    assert_predicate testpath/"output", :exist?
    assert_equal("bar", File.read("output"))
  end
end
