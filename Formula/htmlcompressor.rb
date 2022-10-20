class Htmlcompressor < Formula
  desc "Minify HTML or XML"
  homepage "https://code.google.com/archive/p/htmlcompressor/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/htmlcompressor/htmlcompressor-1.5.3.jar"
  sha256 "88894e330cdb0e418e805136d424f4c262236b1aa3683e51037cdb66310cb0f9"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "2db5110c6d610644c27557492055c3d56573908b50877e2ddd7e6dad556376d7"
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
