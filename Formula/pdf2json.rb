class Pdf2json < Formula
  desc "PDF to JSON and XML converter"
  homepage "https://github.com/flexpaper/pdf2json"
  url "https://github.com/flexpaper/pdf2json/releases/download/v0.68/pdf2json-0.68.tar.gz"
  sha256 "34907954b2029a51a0b372b9db86d6c5112e4a1648201352e514ca5606050673"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a692a971b1e57a0948a1dc0664043d982df1b70cef8a8f39a70f84359bedffd" => :sierra
    sha256 "01a63a2a56b0209884b0edf4d4857cbea4316f2a475dc17a8e390b36536b5d0a" => :el_capitan
    sha256 "c82fefb4779c474d6a6b5eaa0e6fd6a9ccf7bd7e3962b5943367e15e6cbbdea1" => :yosemite
    sha256 "79fb8c9376d0dcc0ec6d9100912f533d9b7301ab9c6a2b90d2564701eaacaa4a" => :mavericks
    sha256 "6796505fd330e4806d40d07804532eb97b9d4cdb8c0a1d270727b9181b4b7ab9" => :mountain_lion
  end

  def install
    system "./configure"
    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}"
    bin.install "src/pdf2json"
  end

  test do
    system bin/"pdf2json", test_fixtures("test.pdf"), "test.json"
    assert File.exist?("test.json")
  end
end
