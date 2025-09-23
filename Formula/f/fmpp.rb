class Fmpp < Formula
  desc "Text file preprocessing tool using FreeMarker templates"
  homepage "https://fmpp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/fmpp/fmpp/0.9.16/fmpp_0.9.16.tar.gz"
  sha256 "86561e3f3a2ccb436f5f3df88d79a7dad72549a33191901f49d12a38b53759cd"
  license "Apache-2.0"
  revision 2

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "fd2a84f1e4cb90f27ac04f99af1b5da3499c81e111e78370ebd71f448dd97d12"
  end

  depends_on "openjdk"

  def install
    libexec.install "lib"
    bin.write_jar_script libexec/"lib/fmpp.jar", "fmpp", "-Dfmpp.home=\"#{libexec}\" $FMPP_OPTS $FMPP_ARGS"
  end

  test do
    (testpath/"input").write '<#assign foo="bar"/>${foo}'
    system bin/"fmpp", "input", "-o", "output"
    assert_path_exists testpath/"output"
    assert_equal("bar", File.read("output"))
  end
end
