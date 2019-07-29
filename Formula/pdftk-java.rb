class PdftkJava < Formula
  desc "Port of pdftk in java"
  homepage "https://gitlab.com/pdftk-java/pdftk"
  url "https://gitlab.com/pdftk-java/pdftk/-/archive/v3.0.6/pdftk-v3.0.6.tar.gz"
  sha256 "bcc19573cd2cc316f8bd2039f01dd1b3b717405a25c58db589bde198bc63068b"
  head "https://gitlab.com/pdftk-java/pdftk.git"

  depends_on "gradle" => :build
  depends_on :java => "1.7+"

  def install
    system "gradle", "shadowJar", "--no-daemon"
    libexec.install "build/libs/pdftk.jar"
    bin.write_jar_script libexec/"pdftk.jar", "pdftk", :java_version => "1.7+"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output_path = testpath/"output.pdf"
    system bin/"pdftk", pdf, pdf, "cat", "output", output_path
    assert output_path.read.start_with?("%PDF")
  end
end
