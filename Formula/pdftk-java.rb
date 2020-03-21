class PdftkJava < Formula
  desc "Port of pdftk in java"
  homepage "https://gitlab.com/pdftk-java/pdftk"
  url "https://gitlab.com/pdftk-java/pdftk/-/archive/v3.1.3/pdftk-v3.1.3.tar.gz"
  sha256 "d9145976adf2dd5f8cd70e1e2345262e46790be6bfb2da1728a2ad4f6e4b2021"
  revision 1
  head "https://gitlab.com/pdftk-java/pdftk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e53bbd046b64c720eb40087858529a1ca03a34c3b177d9b6f7375368456f8878" => :catalina
    sha256 "8ad12f6f341128ed0963dd74814342f01afa1f635835f48af33ddba28a55439b" => :mojave
    sha256 "ae1b26b9ca6f455bc39eb358cdbd01036b7f387d15e0a6f670af54f6d6394b08" => :high_sierra
  end

  depends_on "gradle" => :build
  depends_on :java => "1.8"

  def install
    system "gradle", "shadowJar", "--no-daemon"
    libexec.install "build/libs/pdftk-all.jar"
    bin.write_jar_script libexec/"pdftk-all.jar", "pdftk", :java_version => "1.8"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output_path = testpath/"output.pdf"
    system bin/"pdftk", pdf, pdf, "cat", "output", output_path
    assert output_path.read.start_with?("%PDF")
  end
end
