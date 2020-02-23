class Gammalib < Formula
  desc "Toolbox for the analysis of astronomical gamma-ray data"
  homepage "http://cta.irap.omp.eu/gammalib/about.html"
  url "http://cta.irap.omp.eu/ctools/releases/gammalib/gammalib-1.6.3.tar.gz"
  sha256 "b93bc03562ba1fcb21ab6f48943f9c28230c04d1b0ef986569c88b05d8e9dbbe"
  revision 1

  depends_on "cfitsio"
  depends_on "doxygen"
  depends_on "ncurses"
  depends_on "python"
  depends_on "readline"
  depends_on "swig"

  def install
    system "./configure", "PYTHON=/usr/local/bin/python3", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  def caveats; <<~EOS
    Because gammalib depends on several installation-dependent
    environment variables to function properly, you should
    add the following commands to your shell initialization
    script or call them directly
    before using gammalib.

    For zsh users:
      export GAMMALIB=/usr/local/
      source $GAMMALIB/bin/gammalib-init.sh
  EOS
  end

  test do
    (testpath/"test.py").write <<~EOS
      import gammalib
      print(gammalib.__version__)
    EOS
    assert_match /1.6.3/, shell_output("python test.py")
  end
end
