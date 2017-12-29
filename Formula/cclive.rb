class Cclive < Formula
  desc "Command-line video extraction utility"
  homepage "https://cclive.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/cclive/0.9/cclive-0.9.3.tar.xz"
  sha256 "2edeaf5d76455723577e0b593f0322a97f1e0c8b0cffcc70eca8b5d17374a495"

  bottle do
    cellar :any
    sha256 "65a00aa88ea96cff176c5bdfd29d97686548cfaa362aaa99ff2ed9fe10d9c624" => :high_sierra
    sha256 "a589260223c5b92d0b29551e98e068814311de8ddde82e158063bec6f834aa2d" => :sierra
    sha256 "e77474769e3fa5b12b81fba7d476a9feeb237a9b6ba9bf9cf275e4783203c67d" => :el_capitan
    sha256 "933a9b935bb868923702489a97780998c450c2c220a63786542bf65bfb2db155" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "glibmm"
  depends_on "libquvi"
  depends_on "pcre"

  conflicts_with "clozure-cl", :because => "both install a ccl binary"

  # Upstream PR from 26 Dec 2014 "Add explicit <iostream> includes, fixes build
  # with Boost 1.56"
  patch do
    url "https://github.com/legatvs/cclive/pull/2.patch?full_index=1"
    sha256 "a4cc99e6b78701c8106871b690c899b95d36d8f873ff4d212e63d8f3f45a990f"
  end

  # Fix build errors due to assumption of glibc's strerror_r and due to C++11
  # requirement that there be a space between literal and identifier.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/1266537/cclive/cxx11-and-strerror_r.diff"
    sha256 "38ce495646de295e8cb2d6712d82f2d995db0601649197bc17ab01c5027e7845"
  end

  needs :cxx11

  def install
    ENV.cxx11

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
