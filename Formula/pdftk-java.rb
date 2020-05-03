class PdftkJava < Formula
  desc "Port of pdftk in java"
  homepage "https://gitlab.com/pdftk-java/pdftk"
  url "https://gitlab.com/pdftk-java/pdftk/-/archive/v3.1.1/pdftk-v3.1.1.tar.gz"
  sha256 "7538772dfc9a8b7a969d13f4a61ce693e77026043fb205a4839db92a9a7b8f51"
  head "https://gitlab.com/pdftk-java/pdftk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9f2bad4b0697701837747055309581a2f722140e619f8211e8af3b60399311d0" => :catalina
    sha256 "86540c3aea1b817a1423e3c7b8c1af0e1c01d2579f4f8bf22aaaa7fe2da5602b" => :mojave
    sha256 "05fc4aff36077b66e3bc768c7dddb309e45d976f3a996a75a9191c8a88f8c0f6" => :high_sierra
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
