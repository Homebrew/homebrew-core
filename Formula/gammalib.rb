class Gammalib < Formula
  desc "Toolbox for the analysis of astronomical gamma-ray data"
  homepage "http://cta.irap.omp.eu/gammalib/about.html"
  url "http://cta.irap.omp.eu/ctools/releases/gammalib/gammalib-1.6.3.tar.gz"
  sha256 "b93bc03562ba1fcb21ab6f48943f9c28230c04d1b0ef986569c88b05d8e9dbbe"

  depends_on "cfitsio"
  depends_on "doxygen"
  depends_on "python"
  depends_on "readline"
  depends_on "swig"
  uses_from_macos "ncurses"

  def install
    system "./configure", "PYTHON=/usr/local/bin/python3", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  def caveats; <<~EOS
    Because gammalib expects a set of environment variables you should source:
      export GAMMALIB=/usr/local/
      source $GAMMALIB/bin/gammalib-init.sh
    before using gammalib.
  EOS
  end

  test do
    (testpath/"test.py").write <<~EOS
      import gammalib
      dir=gammalib.GSkyDir()
      dir.radec_deg(83.63,22.01)
      l=dir.l_deg()
      print(l)
    EOS
    assert_match /184.55973405309402/, shell_output("python test.py")
  end
end
