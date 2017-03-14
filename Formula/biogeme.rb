class Biogeme < Formula
  desc "Maximum likelihood estimation of choice models"
  homepage "http://biogeme.epfl.ch"
  url "http://biogeme.epfl.ch/distrib/biogeme-2.5.tar.gz"
  sha256 "88548e99f4f83c24bf7ddb8e0de07588adc2bec515569c56e816ed5b20a624b3"

  option "with-bison", "Install also Bison Biogeme"
  option "with-gui", "Install also a graphical user interface"
  option "without-python", "Does not install Python Biogeme"
  depends_on :python3 if build.with? "python"
  depends_on "gtkmm3" if build.with? "gui"

  def install
    args = %W[
      --prefix=#{prefix}
    ]
    args << "--enable-python" if build.with? "python"
    args << "--enable-bison" if build.with?("bison") || build.with?("gui")
    args << "--enable-gui" if build.with? "gui"

    system "./configure", *args
    system "make", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test biogeme`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    (testpath/"minimal.py").write("from biogeme import *\nrowIterator('obsIter')\nBIOGEME_OBJECT.SIMULATE = Enumerate({'Test':1},'obsIter')")
    (testpath/"minimal.dat").write("TEST\n1\n")
    system bin/"pythonbiogeme", "minimal", "minimal.dat"
  end
end
