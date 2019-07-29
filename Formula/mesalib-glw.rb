class MesalibGlw < Formula
  desc "Open-source implementation of the OpenGL specification"
  homepage "https://www.mesa3d.org"
  url "https://mesa.freedesktop.org/archive/glw/glw-8.0.0.tar.bz2"
  sha256 "2da1d06e825f073dcbad264aec7b45c649100e5bcde688ac3035b34c8dbc8597"

  bottle do
    cellar :any
    sha256 "2792091234f355f3649eb59dafbcff48abda8cc68ffd78e87ca69621b3d6bf61" => :mojave
    sha256 "56a6531c8cc2bdb9dced7a17c0875b13cc774f591d5b4ea64e16fa17b09d8d72" => :high_sierra
    sha256 "c0f19ff9584a9450f0f06bfc6013e1ff7e8cefd520c9d4f0fba1cf3c1b5ce7fc" => :sierra
    sha256 "340b10f7e65eea02edd9853ff14e5458107c1fb3af99f9bf84b8913e3d96918e" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on :x11

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make", "install"
  end
end
