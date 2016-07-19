class Htmlcxx < Formula
  desc "Non-validating CSS1 and HTML parser for C++"
  homepage "http://htmlcxx.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/htmlcxx/htmlcxx/0.86/htmlcxx-0.86.tar.gz"
  sha256 "07542b5ea2442143b125ba213b6823ff4a23fff352ecdd84bbebe1d154f4f5c1"

  bottle do
    sha256 "708b5eeb03eb5f2070f4fe34efb80f9198009a23106c98ec9aaf5472b49dbf1c" => :el_capitan
    sha256 "a013c7a43b1587c458df1ebae586d4b15b2a3c994c7de12dc6c7c24a80886a09" => :yosemite
    sha256 "fceb4660730162bdb44be089ab347afd7a24b3f06bc3579cffdf2bb5891466f5" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/htmlcxx -V 2>&1").chomp
  end
end
