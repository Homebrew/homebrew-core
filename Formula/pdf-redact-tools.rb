class PdfRedactTools < Formula
  desc "Securely redacting and stripping metadata"
  homepage "https://github.com/firstlookmedia/pdf-redact-tools"
  url "https://github.com/firstlookmedia/pdf-redact-tools/archive/v0.1.1.tar.gz"
  sha256 "1b6ade577f2eeb8ea6ddfd1b7b9a6925a6c9a929ea98700e8015676ee1a13155"
  head "https://github.com/firstlookmedia/pdf-redact-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "307a77850976866c2e12a782bff0b42983a75b722411420709d7f624c2cfba4f" => :sierra
    sha256 "660fd61a0bb83272ec2d5e818435484ff53d5a88f7bc619fcccafd5c5e855203" => :el_capitan
    sha256 "1bfb6823d1c7e94f37cf86a3d30bcd777873b69f1a58556dcb7f3d2d25cd4123" => :yosemite
    sha256 "13ef89b6f2f20f22513412f4a4b7f815fe297276a451097228df21bb8835e610" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
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
    assert File.exist?("test_pages/page-0.png")
    rm_rf "test_pages"

    system bin/"pdf-redact-tools", "-s", "test.pdf"
    assert File.exist?("test-final.pdf")
  end
end
