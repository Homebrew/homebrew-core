class PdfRedactTools < Formula
  desc "Securely redacting and stripping metadata"
  homepage "https://github.com/firstlookmedia/pdf-redact-tools"
  url "https://github.com/firstlookmedia/pdf-redact-tools/archive/v0.1.2.tar.gz"
  sha256 "5874a7b76be15ccaa4c20874299ef51fbaf520a858229a58678bc72a305305fc"
  head "https://github.com/firstlookmedia/pdf-redact-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "11fd822d0242f88b0f6a165b386f882209e50e349f439f9680c949507be30604" => :mojave
    sha256 "7f079c910f0bc8287cfdabfcafd92c57662b0d40c07e2d3fb6b55a953631c330" => :high_sierra
    sha256 "80b4e04bd761bad0cfdea11abfcd19cf96b785cf4e2877998f17bb8a8136afb0" => :sierra
    sha256 "b462fadc539b2c646c9ff8a59b98df344d0a6cb2fb010c2d4a82785d2f0007e6" => :el_capitan
    sha256 "b462fadc539b2c646c9ff8a59b98df344d0a6cb2fb010c2d4a82785d2f0007e6" => :yosemite
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
