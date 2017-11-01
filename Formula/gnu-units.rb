class GnuUnits < Formula
  desc "GNU unit conversion tool"
  homepage "https://www.gnu.org/software/units/"
  url "https://ftp.gnu.org/gnu/units/units-2.16.tar.gz"
  mirror "https://ftpmirror.gnu.org/units/units-2.16.tar.gz"
  sha256 "dcf3f78482a13b150fc6bf0f8d611510816a3424bc2b26229b85b1cadeb81686"

  bottle do
    sha256 "b533470458d0a2bd9bfe0fbc065537b7c90c430c0d7285df5d46336ab5176d72" => :high_sierra
    sha256 "72cc1855be6ce7d394d4cd57523a6c79f6f8125a15dbd88cb33a30bb6eaac221" => :sierra
    sha256 "fc309d161150a8141003950b96c8876a4f4814810c9936dd6f0561220da682e5" => :el_capitan
  end

  deprecated_option "default-names" => "with-default-names"

  option "with-default-names", "Do not prepend 'g' to the binary"

  depends_on "readline"

  def install
    args = ["--prefix=#{prefix}", "--with-installed-readline"]
    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_equal "* 18288", shell_output("#{bin}/gunits '600 feet' 'cm' -1").strip
  end
end
