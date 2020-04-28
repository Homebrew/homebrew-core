class Detox < Formula
  desc "Utility to replace problematic characters in filenames"
  homepage "https://detox.sourceforge.io/"
  url "https://github.com/dharple/detox/archive/v1.3.0.tar.gz"
  sha256 "00daf6b019b51c7bbc3ac96deeeec18fd886c144eeee97c3372dd297bb134c84"

  bottle do
    sha256 "2cc99380391d297e584a9404e9d34bb170de0a4d13604fe3f8022d387466f110" => :catalina
    sha256 "27f6c89ac907aa01aa0073b4244457a20441c0cb1871114763fdc0aba83fa096" => :mojave
    sha256 "133b073b5e24308a29cbc63c3a8a2ee02a46c23b66d76b61057f330ea075e558" => :high_sierra
    sha256 "0cc58044463abf09129c9d7a1c49df5ebb51f9d6e675233f8dce404aa6a6c69f" => :sierra
    sha256 "886f37ab52a92b8cbc82bd6c0be49efbf56c9186903f9d3b3652b0ddb0555329" => :el_capitan
    sha256 "0e1939ae85d72e1c941c1eb58bce8839b393c052221ef848373b518e3927cc59" => :yosemite
    sha256 "a7bc2b7ecd5ae46a389973aab9f1506fa8ce67117bc4fbdead2b38d7eae732ce" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--mandir=#{man}", "--prefix=#{prefix}"
    system "make"
    (prefix/"etc").mkpath
    pkgshare.mkpath
    system "make", "install"
  end

  test do
    (testpath/"rename this").write "foobar"
    assert_equal "rename this -> rename_this\n", shell_output("#{bin}/detox --dry-run rename\\ this")
  end
end
