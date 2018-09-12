class PdfRedactTools < Formula
  desc "Securely redacting and stripping metadata"
  homepage "https://github.com/firstlookmedia/pdf-redact-tools"
  url "https://github.com/firstlookmedia/pdf-redact-tools/archive/v0.1.2.tar.gz"
  sha256 "5874a7b76be15ccaa4c20874299ef51fbaf520a858229a58678bc72a305305fc"
  head "https://github.com/firstlookmedia/pdf-redact-tools.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "57ca77cff062d910ddf754b3b8604e6bbc25c0cef9d5eed10d9be31a3e09f9c6" => :mojave
    sha256 "2f365098071c52ccf595a93d708dec02fa25fbaee0a9c0a30026b20d313b8147" => :high_sierra
    sha256 "2f365098071c52ccf595a93d708dec02fa25fbaee0a9c0a30026b20d313b8147" => :sierra
    sha256 "2f365098071c52ccf595a93d708dec02fa25fbaee0a9c0a30026b20d313b8147" => :el_capitan
  end

  depends_on "python@2"
  depends_on "imagemagick"
  depends_on "exiftool"
  depends_on "ghostscript"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    # Ensures pdf-redact-tools correctly recognises the file isn't a
    # PDF and exits. Cannot test further than this without loosening
    # our default imagemagick security policy.
    cp test_fixtures("test.png"), "test"
    output = shell_output("#{bin}/pdf-redact-tools --sanitize test 2>&1", 2)
    assert_match "file must be a PDF", output
  end
end
