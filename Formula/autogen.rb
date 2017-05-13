class Autogen < Formula
  desc "Automated text file generator"
  homepage "https://autogen.sourceforge.io"
  url "https://ftp.gnu.org/gnu/autogen/autogen-5.18.7.tar.xz"
  mirror "https://ftpmirror.gnu.org/autogen/autogen-5.18.7.tar.xz"
  sha256 "a7a580a5e18931cb341b255cec2fee2dfd81bea5ddbf0d8ad722703e19aaa405"
  revision 1

  bottle do
    sha256 "9d4b6c3aba83225c84cc669aa8b4f9cd975e427ea8b669fb6a36f9bb94ffd019" => :sierra
    sha256 "f725f6b398ce1976aabbede2a9abfd44b4aecd49278b2f98d7c8d9d4e3631a25" => :el_capitan
    sha256 "24e1800bb32f5249e5ed111c27cba2f8093c5bcb7f62dfc53570efbe8caa5bb6" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "guile"

  # Allow guile 2.2 to be used
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/0de886b/autogen/allow-guile-2.2.diff"
    sha256 "438fe673432c96d5da449b84daa4d1c6ad238ea0b4ccd13491872df8c51fa978"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    # make and install must be separate steps for this formula
    system "make"
    system "make", "install"
  end

  test do
    system bin/"autogen", "-v"
  end
end
