# Documentation: http://docs.brew.sh/Formula-Cookbook.html
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class ClawsMail < Formula
  desc "Claws Mail e-mail client"
  homepage "http://www.claws-mail.org"
  url "http://www.claws-mail.org/download.php?file=releases/claws-mail-3.15.0.tar.xz"
  sha256 "4e4d2d0d43f8ae3d4623408612f5979e9a697ccbc12038b80dd27802e868dc2e"

  head 'http://git.claws-mail.org/readonly/claws.git'

  depends_on :x11 # if your formula requires any X11/XQuartz components
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gettext"
  depends_on "gtk+"
  depends_on "libetpan"
  depends_on "libarchive"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "true"
  end
end
