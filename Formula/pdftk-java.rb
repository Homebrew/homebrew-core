class PdftkJava < Formula
  desc "Port of pdftk in java"
  homepage "https://gitlab.com/pdftk-java/pdftk"
  url "https://gitlab.com/pdftk-java/pdftk/-/archive/v3.2.1/pdftk-v3.2.1.tar.gz"
  sha256 "16aacc54d5b3cd5da35e0d8e09a51bf4e5938f289cf32d09ef9225dda99041ed"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/pdftk-java/pdftk.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f00be6966a7e0cda154d007da70b5bd79e07ec5eb0d48b131019274b1d4c0d14" => :catalina
    sha256 "ba564a281117f812b361c9c5e79b8f8d32530e81bc4904dc466ad55ed94d2b90" => :mojave
    sha256 "ec218f53c094e6aeac71bfa7b57ca066f41e3fbc7a0f9c665155a88ca26affde" => :high_sierra
  end

  depends_on "gradle" => :build
  depends_on java: "1.8"

  def install
    system "gradle", "shadowJar", "--no-daemon"
    libexec.install "build/libs/pdftk-all.jar"
    bin.write_jar_script libexec/"pdftk-all.jar", "pdftk", " -Djava.awt.headless=true ", java_version: "1.8"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output_path = testpath/"output.pdf"
    system bin/"pdftk", pdf, pdf, "cat", "output", output_path
    assert output_path.read.start_with?("%PDF")
  end
end
