class PdftkJava < Formula
  desc "Port of pdftk in java"
  homepage "https://gitlab.com/pdftk-java/pdftk"
  url "https://gitlab.com/pdftk-java/pdftk/-/archive/v3.1.3/pdftk-v3.1.3.tar.gz"
  sha256 "d9145976adf2dd5f8cd70e1e2345262e46790be6bfb2da1728a2ad4f6e4b2021"
  license "GPL-2.0"
  revision 1
  head "https://gitlab.com/pdftk-java/pdftk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3eb4ac53b5e6f4603509e5eb785c3574a050df65252b1f6aeb6f9f7300604fd4" => :catalina
    sha256 "a269cdfe44ed002b830a5e574f49b9eec4923b0cc3ad791b3cb46773d2952c40" => :mojave
    sha256 "72e5f070fa22a8f394a6fcdfe1b40a65f95ee945f655377677106a7a369b8c08" => :high_sierra
  end

  depends_on "gradle" => :build
  depends_on java: "1.8"

  def install
    system "gradle", "shadowJar", "--no-daemon"
    libexec.install "build/libs/pdftk-all.jar"
    bin.write_jar_script libexec/"pdftk-all.jar", "pdftk", java_version: "1.8"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output_path = testpath/"output.pdf"
    system bin/"pdftk", pdf, pdf, "cat", "output", output_path
    assert output_path.read.start_with?("%PDF")
  end
end
