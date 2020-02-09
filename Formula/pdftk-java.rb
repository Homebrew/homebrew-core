class PdftkJava < Formula
  desc "Port of pdftk in java"
  homepage "https://gitlab.com/pdftk-java/pdftk"
  url "https://gitlab.com/pdftk-java/pdftk/-/archive/v3.0.9/pdftk-v3.0.9.tar.gz"
  sha256 "8210167286849552eff08199e7734223c6ae9b7f1875e4e2b5b6e7996514dd10"
  head "https://gitlab.com/pdftk-java/pdftk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f1d1b6bb4a694679a2340f0075b050bd6c26e71075f88f6dff5ef6bc16d4e4a1" => :catalina
    sha256 "3f3f261f034dd2cdf781b776f5d89bb08eb58168346739460693102188bffcfc" => :mojave
    sha256 "487dc134781c5cad3be5db550b9bf2c302401d4ab7b47b8e90822e25bec72dc3" => :high_sierra
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
