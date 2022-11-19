class Optipng < Formula
  desc "PNG file optimizer"
  homepage "https://optipng.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/optipng/OptiPNG/optipng-0.7.7/optipng-0.7.7.tar.gz"
  sha256 "4f32f233cef870b3f95d3ad6428bfe4224ef34908f1b42b0badf858216654452"
  license "Zlib"
  head "http://hg.code.sf.net/p/optipng/mercurial", using: :hg

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "0f832f65504580d7eeda792024065ad257118cf15f94d2df0dd8cb12dc9880f0"
    sha256 cellar: :any,                 arm64_monterey: "9392bd48565d6102eb0991d836040944055394863d5a186fd617a7788032f91c"
    sha256 cellar: :any,                 arm64_big_sur:  "796af028b1dea8b680e40103712976b4f9df285df553db06d2643779630c716c"
    sha256 cellar: :any,                 ventura:        "f09c4149b72ff18a1689820a4872f3037242c82c6bf73b621eafcdf828fc829a"
    sha256 cellar: :any,                 monterey:       "c366c7c45b9cb9c2e97e001fcf3cf008fdc1843da37cc42f7c0fa864d0311f22"
    sha256 cellar: :any,                 big_sur:        "5cee26efb92016f057a55b2711a08c4a0350046b7c0b1d969c75a913caf66fc2"
    sha256 cellar: :any,                 catalina:       "3d423dfa59e07122f70e2a15026289dfc6884798ac76898065dbe587256c6e35"
    sha256 cellar: :any,                 mojave:         "bd44fa66b00a6ee0340a9a5b239d22823787fcaa26312783b21c0f4afc39fd0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e515f83962de17813907616541a6e9bdcb3b51a64db9f4c58abd8c5960a47764"
  end

  depends_on "libpng"

  uses_from_macos "zlib"

  def install
    system "./configure", "--with-system-zlib",
                          "--with-system-libpng",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/optipng", "-simulate", test_fixtures("test.png")
  end
end
