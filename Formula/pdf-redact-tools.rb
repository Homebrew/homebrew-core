class PdfRedactTools < Formula
  desc "Securely redacting and stripping metadata"
  homepage "https://github.com/firstlookmedia/pdf-redact-tools"
  url "https://github.com/firstlookmedia/pdf-redact-tools/archive/v0.1.2.tar.gz"
  sha256 "5874a7b76be15ccaa4c20874299ef51fbaf520a858229a58678bc72a305305fc"
  revision 1
  head "https://github.com/firstlookmedia/pdf-redact-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d36fd54bdf0fecba50c0d2e4c8ec7c4702bc626b7228f55482fa04527837e80a" => :catalina
    sha256 "1d5dddb4adc486d89537a5368550c787b9dbae0c6cd9cddba9b2e45820b025e1" => :mojave
    sha256 "1d5dddb4adc486d89537a5368550c787b9dbae0c6cd9cddba9b2e45820b025e1" => :high_sierra
  end

  depends_on "exiftool"
  depends_on "ghostscript"
  depends_on "imagemagick"

  # https://github.com/firstlookmedia/pdf-redact-tools/pull/34
  uses_from_macos "python@2" # does not support Python 3

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    # Modifies the file in the directory the file is placed in.
    cp test_fixtures("test.pdf"), "test.pdf"
    system bin/"pdf-redact-tools", "-e", "test.pdf"
    assert_predicate testpath/"test_pages/page-0.png", :exist?
    rm_rf "test_pages"

    system bin/"pdf-redact-tools", "-s", "test.pdf"
    assert_predicate testpath/"test-final.pdf", :exist?
  end
end
