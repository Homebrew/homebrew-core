class PdfRedactTools < Formula
  desc "Securely redacting and stripping metadata"
  homepage "https://github.com/firstlookmedia/pdf-redact-tools"
  url "https://github.com/firstlookmedia/pdf-redact-tools/archive/v0.1.2.tar.gz"
  sha256 "5874a7b76be15ccaa4c20874299ef51fbaf520a858229a58678bc72a305305fc"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/firstlookmedia/pdf-redact-tools.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7c70360f14e7dd09fe4d29e86fdd98a40688f60bbd24475b5c9ff54f8dc526db" => :big_sur
    sha256 "7f949403c9b5927ae95adf02b32c8f7c74cff9ee14881d50f5634850fc418f2e" => :arm64_big_sur
    sha256 "2b652f29d55bf7d476f02b6ac35c2aab3920709fe72e5390838ee4732a1210da" => :catalina
    sha256 "e89303de13975510234c078756470ac529050a93a4e4a7592b94ef5971cea049" => :mojave
  end

  deprecate! date: "2020-11-20", because: :unmaintained

  depends_on "exiftool"
  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on :macos # Due to Python 2 (https://github.com/firstlookmedia/pdf-redact-tools/pull/34)

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
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
