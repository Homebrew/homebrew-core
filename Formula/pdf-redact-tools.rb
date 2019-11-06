class PdfRedactTools < Formula
  desc "Securely redacting and stripping metadata"
  homepage "https://github.com/firstlookmedia/pdf-redact-tools"
  url "https://github.com/firstlookmedia/pdf-redact-tools/archive/v0.1.2.tar.gz"
  sha256 "5874a7b76be15ccaa4c20874299ef51fbaf520a858229a58678bc72a305305fc"
  head "https://github.com/firstlookmedia/pdf-redact-tools.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "12ada57f6d50314b9661ea8b40bca4e2e3cb901cdb1c50c3bf8f5e450f7d58e6" => :catalina
    sha256 "57ca77cff062d910ddf754b3b8604e6bbc25c0cef9d5eed10d9be31a3e09f9c6" => :mojave
    sha256 "2f365098071c52ccf595a93d708dec02fa25fbaee0a9c0a30026b20d313b8147" => :high_sierra
    sha256 "2f365098071c52ccf595a93d708dec02fa25fbaee0a9c0a30026b20d313b8147" => :sierra
    sha256 "2f365098071c52ccf595a93d708dec02fa25fbaee0a9c0a30026b20d313b8147" => :el_capitan
  end

  depends_on "exiftool"
  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on "python@2" # does not support Python 3

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
