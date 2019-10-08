class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.8.1.tar.gz"
  sha256 "a6174aae72f93b56c6652c2c27d5203e0f867e11a5e1c7d89c4aa3b4bcb67eb3"
  revision 7

  bottle do
    cellar :any
    sha256 "e87321bdee82edb49c6a206f13cce4ab335c704ef7630bc164aa4bd083da5a3b" => :catalina
    sha256 "2b98872436e2df29e37cae41552f635c645d18062747df7c46e246fc18a89498" => :mojave
    sha256 "c82150d32b8492a75ac882f03e41da84ea01073091886d30162281bc12a1910c" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "poppler"

  def install
    ENV.cxx11

    cd "pdftoipe" do
      system "make"
      bin.install "pdftoipe"
      man1.install "pdftoipe.1"
    end
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    system bin/"pdftoipe", "test.pdf"
    assert_match "Homebrew test.</text>", File.read("test.ipe")
  end
end
