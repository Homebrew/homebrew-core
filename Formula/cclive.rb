class Cclive < Formula
  desc "Command-line video extraction utility"
  homepage "https://cclive.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/cclive/0.7/cclive-0.7.16.tar.xz"
  sha256 "586a120faddcfa16f5bb058b5c901f1659336c6fc85a0d3f1538882a44ee10e1"
  revision 2

  bottle do
    cellar :any
    sha256 "d4095cb6cf397b7e2e99e29d9364fcd5dc6cc9df58d5e5da0ce4b51e773d1978" => :sierra
    sha256 "c712f413a8720abfbba83c4c385ac4d2664a2736b4c0ee0dbde77a722f9310db" => :el_capitan
    sha256 "a5d34ca6db2e83f4a2aff10870cb6fb9ed87782bb71058b2b978752b89bd97b7" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "quvi"
  depends_on "boost"
  depends_on "pcre"

  conflicts_with "clozure-cl", :because => "both install a ccl binary"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    url = "https://youtu.be/VaVZL7F6vqU"
    output = shell_output("#{bin}/cclive --no-download #{url} 2>&1")
    assert_match "Martin Luther King Jr Day", output
  end
end
