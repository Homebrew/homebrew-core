class PdfRedactTools < Formula
  desc "Securely redacting and stripping metadata"
  homepage "https://github.com/micahflee/pdf-redact-tools"
  url "https://github.com/firstlookmedia/pdf-redact-tools/archive/v0.1.1.tar.gz"
  sha256 "1b6ade577f2eeb8ea6ddfd1b7b9a6925a6c9a929ea98700e8015676ee1a13155"
  head "https://github.com/firstlookmedia/pdf-redact-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "17c2dd805cf6f02dbd9f87c2f8c492abee296f08d0190699179a76eb1caad4e6" => :el_capitan
    sha256 "4c841b25222983bc322fc1551a0142b34baa5033f560ec06d8a48c3e43dfea7d" => :yosemite
    sha256 "a18d2048339064b527df22c675c8417fc5c2771d0dfb4176c8bd66ffc3e714c1" => :mavericks
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
