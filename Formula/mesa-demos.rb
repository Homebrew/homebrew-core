class MesaDemos < Formula
  desc "Mesa demos and tools incl. glxinfo + glxgears"
  homepage "https://www.mesa3d.org/"
  url "https://mesa.freedesktop.org/archive/demos/mesa-demos-8.4.0.tar.bz2"
  sha256 "01e99c94a0184e63e796728af89bfac559795fb2a0d6f506fa900455ca5fff7d"
  head "https://gitlab.freedesktop.org/mesa/demos.git"

  depends_on "pkg-config" => :build
  depends_on "freeglut"
  depends_on "glew"
  depends_on "mesa"
  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "false"
  end
end
