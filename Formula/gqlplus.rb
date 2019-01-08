class Gqlplus < Formula
  desc "Drop-in replacement for sqlplus, an Oracle SQL client"
  homepage "https://gqlplus.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gqlplus/gqlplus/1.16/gqlplus-1.16.tar.gz"
  sha256 "9e0071d6f8bc24b0b3623c69d9205f7d3a19c2cb32b5ac9cff133dc75814acdd"
  revision 2

  bottle do
    cellar :any
    sha256 "5b58c9a3dceddb3d74fd3e0351a4fd891a769e767da5f2860fe4d907b1ef8f82" => :mojave
    sha256 "eab5cbb0829e7ca64cfca5c9d08318fb75373b3f8862934ca0ea6e9ec6e0946b" => :high_sierra
    sha256 "b2f33f3ffc90c73e030608a4f244a5f6589fc07107e3ed71bfed134575680e33" => :sierra
    sha256 "ed88c481e0874760c39f3bf469d76487376d7f4b007863883113721a451a3057" => :el_capitan
    sha256 "947f55e662848bedc30652c51adf55960a8da7c9db3ff3e5940eee19767f2b1c" => :yosemite
  end

  depends_on "readline"

  def install
    # Fix the version
    # Reported 18 Jul 2016: https://sourceforge.net/p/gqlplus/bugs/43/
    inreplace "gqlplus.c",
      "#define VERSION          \"1.15\"",
      "#define VERSION          \"1.16\""

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gqlplus -h")
  end
end
