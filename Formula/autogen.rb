class Autogen < Formula
  desc "Automated text file generator"
  homepage "https://autogen.sourceforge.io"
  url "https://ftp.gnu.org/gnu/autogen/rel5.18.12/autogen-5.18.12.tar.xz"
  mirror "https://ftpmirror.gnu.org/autogen/rel5.18.12/autogen-5.18.12.tar.xz"
  sha256 "be3ba62e883185b6ee8475edae97d7197d701d6b9ad9c3d2df53697110c1bfd8"
  revision 1

  bottle do
    sha256 "c9835af12e309b7992918e64fc766f59ca50ff3f4e846434d74141859d638cd8" => :high_sierra
    sha256 "c80dbb65f3afee35378aadaf766cd3d772d39256ec6d48b9864ecab018a931e9" => :sierra
    sha256 "ff8c66ca7d86c309e884dad0fcc49aadf65a830768a0551c5711cba2f6d6a046" => :el_capitan
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
