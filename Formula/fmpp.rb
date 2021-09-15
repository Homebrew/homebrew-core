class Fmpp < Formula
  desc "Text file preprocessing tool using FreeMarker templates"
  homepage "https://fmpp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/fmpp/fmpp/0.9.16/fmpp_0.9.16.tar.gz"
  sha256 "86561e3f3a2ccb436f5f3df88d79a7dad72549a33191901f49d12a38b53759cd"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dc3512d37ce269108177103bb974dd7d033985a4ab441428217362b9fc8513ef"
  end

  depends_on "openjdk"

  def install
    libexec.install "lib"
    bin.write_jar_script libexec/"lib/fmpp.jar", "fmpp", "-Dfmpp.home=\"#{libexec}\" $FMPP_OPTS $FMPP_ARGS"
  end

  test do
    (testpath/"input").write '<#assign foo="bar"/>${foo}'
    system bin/"fmpp", "input", "-o", "output"
    assert_predicate testpath/"output", :exist?
    assert_equal("bar", File.read("output"))
  end
end
