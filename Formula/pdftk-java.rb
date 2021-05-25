class PdftkJava < Formula
  desc "Port of pdftk in java"
  homepage "https://gitlab.com/pdftk-java/pdftk"
  url "https://gitlab.com/pdftk-java/pdftk/-/archive/v3.2.2/pdftk-v3.2.2.tar.gz"
  sha256 "b284e413dd43fe440152360eccbc5cb9ffd8978be8313ffc060bfebb74d14bf1"
  license "GPL-2.0-or-later"
  revision 1
  head "https://gitlab.com/pdftk-java/pdftk.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "ffdb2223acf7f8d98bf76d22f5f279260e54cdc7e176014ad60333e4fcfa0ae8"
    sha256 cellar: :any_skip_relocation, catalina: "5a1fd7374b63c532225969c45f8498c10ed81ffcada9eb734486fec50a57c933"
    sha256 cellar: :any_skip_relocation, mojave:   "22b7aa38e268dfdd06b933d46f3c820caf78aa39e234711968ebdede8b744bc1"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    system "gradle", "shadowJar", "--no-daemon"
    libexec.install "build/libs/pdftk-all.jar"
    bin.write_jar_script libexec/"pdftk-all.jar", "pdftk"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output_path = testpath/"output.pdf"
    system bin/"pdftk", pdf, pdf, "cat", "output", output_path
    assert output_path.read.start_with?("%PDF")
  end
end
