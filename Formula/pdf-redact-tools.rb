class PdfRedactTools < Formula
  desc "Securely redacting and stripping metadata"
  homepage "https://github.com/firstlookmedia/pdf-redact-tools"
  url "https://github.com/firstlookmedia/pdf-redact-tools/archive/v0.1.2.tar.gz"
  sha256 "5874a7b76be15ccaa4c20874299ef51fbaf520a858229a58678bc72a305305fc"
  head "https://github.com/firstlookmedia/pdf-redact-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7f079c910f0bc8287cfdabfcafd92c57662b0d40c07e2d3fb6b55a953631c330" => :high_sierra
    sha256 "80b4e04bd761bad0cfdea11abfcd19cf96b785cf4e2877998f17bb8a8136afb0" => :sierra
    sha256 "b462fadc539b2c646c9ff8a59b98df344d0a6cb2fb010c2d4a82785d2f0007e6" => :el_capitan
    sha256 "b462fadc539b2c646c9ff8a59b98df344d0a6cb2fb010c2d4a82785d2f0007e6" => :yosemite
  end

  depends_on "python" if MacOS.version <= :snow_leopard
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
    # Modifies the file in the directory the file is placed in.
    cp test_fixtures("test.pdf"), "test.pdf"
    system bin/"pdf-redact-tools", "-e", "test.pdf"
    assert_predicate testpath/"test_pages/page-0.png", :exist?
    rm_rf "test_pages"

    system bin/"pdf-redact-tools", "-s", "test.pdf"
    assert_predicate testpath/"test-final.pdf", :exist?
  end
end
