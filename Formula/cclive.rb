class Cclive < Formula
  desc "Command-line video extraction utility"
  homepage "https://cclive.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/cclive/0.7/cclive-0.7.16.tar.xz"
  sha256 "586a120faddcfa16f5bb058b5c901f1659336c6fc85a0d3f1538882a44ee10e1"
  revision 2

  bottle do
    cellar :any
    sha256 "8001f6a23cfef448ee8d58eb05b6d1e497520b8b21851d0f2d2859fc09f74f6d" => :mojave
    sha256 "65a00aa88ea96cff176c5bdfd29d97686548cfaa362aaa99ff2ed9fe10d9c624" => :high_sierra
    sha256 "a589260223c5b92d0b29551e98e068814311de8ddde82e158063bec6f834aa2d" => :sierra
    sha256 "e77474769e3fa5b12b81fba7d476a9feeb237a9b6ba9bf9cf275e4783203c67d" => :el_capitan
    sha256 "933a9b935bb868923702489a97780998c450c2c220a63786542bf65bfb2db155" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "pcre"
  depends_on "quvi"

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
