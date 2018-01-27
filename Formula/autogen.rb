class Autogen < Formula
  desc "Automated text file generator"
  homepage "https://autogen.sourceforge.io"
  url "https://ftp.gnu.org/gnu/autogen/rel5.18.12/autogen-5.18.12.tar.xz"
  mirror "https://ftpmirror.gnu.org/autogen/rel5.18.12/autogen-5.18.12.tar.xz"
  sha256 "be3ba62e883185b6ee8475edae97d7197d701d6b9ad9c3d2df53697110c1bfd8"
  revision 1

  bottle do
    sha256 "b344e8d6ff855acbb8029b43142cca48653d8b18a87a0e46f59c22fcd979b20a" => :high_sierra
    sha256 "5b4c2b7662beab2af5045d8919ababd3404ad6aab567cd5853426680d12be6c7" => :sierra
    sha256 "e2f6a0c2c34c16f50552c40cbe27bf73788cbb978bb572e7adcba0e7d2b94e5c" => :el_capitan
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
