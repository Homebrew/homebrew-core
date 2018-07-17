class Campari < Formula
  desc "Complete suite for Molecular Dynamics simulation AND analysis"
  homepage "https://campari.sourceforge.io/"
  url "https://gitlab.com/CaflischLab/debcampari/-/archive/master/debcampari-master.tar.gz"
  version "3.0.1"
  sha256 "8f4a7e256ea53deb8ce3c2607a86deecb9db35b9a2e49e13cae411cabc83df59"
  depends_on "automake"
  depends_on "fftw"
  depends_on "gcc"
  depends_on "lapack"
  depends_on "netcdf"
  depends_on "open-mpi"
  depends_on "openblas"
  def install
    Dir.chdir("source")
    system "./configure", "--with-hsl=no",
                          "--enable-mpi",
                          "--enable-threads",
                          "--prefix=#{prefix}"
    bin.mkpath
    man.mkpath
    lib.mkpath
    doc.mkpath
    share.mkpath
    system "make", "all_brew"
    bin.install "campari"
    lib.install "../lib/*"
    doc.install "../doc/*"
    share.install "../params"
    share.install "../data"
    share.install "../tools"
    share.install "../examples"
    prefix.install_metafiles
    Dir.chdir("..")
  end
  test do
    Dir.chdir("#{share}/examples/tutorial1")
    system "#{bin}/campari", "-k", "TEMPLATE.key"
  end
end
