class PdftkJava < Formula
  desc "Port of pdftk in java"
  homepage "https://gitlab.com/pdftk-java/pdftk"
  url "https://gitlab.com/pdftk-java/pdftk/-/archive/v3.0.9/pdftk-v3.0.9.tar.gz"
  sha256 "8210167286849552eff08199e7734223c6ae9b7f1875e4e2b5b6e7996514dd10"
  head "https://gitlab.com/pdftk-java/pdftk.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3162c6a5dfc854143c476838c31e671cf02163bb8475b3a046552c1c47fb54ef" => :catalina
    sha256 "bbbadd1e4476c47832c87ca1c8b786a3e50bb4dc8856fb421ba349d874d68b74" => :mojave
    sha256 "9167487c4fa0180827b361089f7e5cac58b3b359c71e6f283172910fcb80952f" => :high_sierra
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
