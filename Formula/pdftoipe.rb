class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.24.1.tar.gz"
  sha256 "561b18fc2a7ae45c37c5d0390443b37f4585549f09cd7765d856456be24e5dbc"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_monterey: "4a6ffbe7e2ef7b51eb07aae9083c85e3a3c4175f32dfbb5555c5795834233d60"
    sha256 cellar: :any, arm64_big_sur:  "3be78e63e115fd6963b99c9e5a64eb1247055a99e60e7b25c025da6206cccc58"
    sha256 cellar: :any, monterey:       "d254bd6044997869924cdce8e3e78a03fd669763686d24170bf561be80d97245"
    sha256 cellar: :any, big_sur:        "8c3553f890fea66f4bd7bb51790ad6dc9ae62fa8f78e43a800a34402ef590953"
    sha256 cellar: :any, catalina:       "c7d7378e5dba9941098c0649e9919ca40abad31bc9c59a90661252c97cd74bd9"
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
    assert_match "<ipestyle>", File.read("test.ipe")
  end
end
