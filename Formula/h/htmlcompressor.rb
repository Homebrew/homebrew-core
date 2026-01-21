class Htmlcompressor < Formula
  desc "Minify HTML or XML"
  homepage "https://code.google.com/archive/p/htmlcompressor/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/htmlcompressor/htmlcompressor-1.5.3.jar"
  sha256 "88894e330cdb0e418e805136d424f4c262236b1aa3683e51037cdb66310cb0f9"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "a8323e2d6001cc0effb3c29900f977118d35fc4a0a86be9cd49d0fa133d04f23"
  end

  depends_on "openjdk"

  def install
    libexec.install "htmlcompressor-#{version}.jar"
    bin.write_jar_script libexec/"htmlcompressor-#{version}.jar", "htmlcompressor"
  end

  test do
    path = testpath/"index.xml"
    path.write <<~EOS
      <foo>
        <bar /> <!-- -->
      </foo>
    EOS

    output = shell_output("#{bin}/htmlcompressor #{path}").strip
    assert_equal "<foo><bar/></foo>", output
  end
end
