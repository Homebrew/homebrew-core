class PdftkJava < Formula
  desc "Port of pdftk in java"
  homepage "https://gitlab.com/pdftk-java/pdftk"
  url "https://gitlab.com/pdftk-java/pdftk/-/archive/v3.2.2/pdftk-v3.2.2.tar.gz"
  sha256 "b284e413dd43fe440152360eccbc5cb9ffd8978be8313ffc060bfebb74d14bf1"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/pdftk-java/pdftk.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ffdb2223acf7f8d98bf76d22f5f279260e54cdc7e176014ad60333e4fcfa0ae8" => :big_sur
    sha256 "5a1fd7374b63c532225969c45f8498c10ed81ffcada9eb734486fec50a57c933" => :catalina
    sha256 "22b7aa38e268dfdd06b933d46f3c820caf78aa39e234711968ebdede8b744bc1" => :mojave
  end

  depends_on "gradle" => :build
  depends_on "openjdk@8"

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
