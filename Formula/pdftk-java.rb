class PdftkJava < Formula
  desc "Port of pdftk in java"
  homepage "https://gitlab.com/pdftk-java/pdftk"
  url "https://gitlab.com/pdftk-java/pdftk/-/archive/v3.0.7/pdftk-v3.0.7.tar.gz"
  sha256 "6f7cb547076c54d1c500a9ff35ba677859cbca4b7b4d73dc14d167f81c00407c"
  head "https://gitlab.com/pdftk-java/pdftk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cbaf90d501a0ca441d45eba5266edabe36f5ebd1301a23a11a81d9aa64ed041a" => :mojave
    sha256 "1ebd86b0815dd2a8ba53e929aa80b413b1c86bc4f1a3777b9ea9cd72eb0f9860" => :high_sierra
    sha256 "9044faaabd52938e8430ac00c96b4ba9fa8afde35f3919fcc05575631381dd21" => :sierra
  end

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
