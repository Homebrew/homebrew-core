class Bokken < Formula
  desc "GUI for the Pyew and Radare projects"
  homepage "http://bokken.re/"
  url "https://inguma.eu/attachments/download/212/bokken-1.8.tar.gz"
  mirror "https://www.mirrorservice.org/sites/ftp.netbsd.org/pub/pkgsrc/distfiles/bokken-1.8.tar.gz"
  sha256 "1c73885147dfcf0a74ba4d3dd897a6aabc11a4a42f95bd1269782d0b2e1a11b9"
  revision 2

  bottle do
    cellar :any
    sha256 "399b38a3c993daac5fe50f1eae4e2530f1bb436be37d0b7899731bf7f453778e" => :high_sierra
    sha256 "4d773862c8aea37e6387c33e459adbcd77c61d53313cf8b57e0009103d5e8ee4" => :sierra
    sha256 "03fb595260541767d40af2eaa67d662b2ca2750495610226f155f81e74866059" => :el_capitan
  end

  depends_on "graphviz"
  depends_on "librsvg"
  depends_on "pygtk"
  depends_on "pygtksourceview"
  depends_on "radare2"

  resource "distorm64" do
    url "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/d/distorm64/distorm64_1.7.30.orig.tar.gz"
    sha256 "98b218e5a436226c5fb30d3b27fcc435128b4e28557c44257ed2ba66bb1a9cf1"
  end

  resource "pyew" do
    # Upstream only provides binary packages so pull from Debian.
    url "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/p/pyew/pyew_2.0.orig.tar.gz"
    sha256 "64a4dfb1850efbe2c9b06108697651f9ff25223fd132eec66c6fe84d5ecc17ae"
  end

  def install
    resource("distorm64").stage do
      inreplace "src/pydistorm.h", "python2\.5", "python2.7"
      cd "build/mac" do
        inreplace "Makefile", "-lpython", "-undefined dynamic_lookup"
        system "make"
        mkdir_p libexec/"distorm64"
        (libexec/"distorm64").install "libdistorm64.dylib"
        ln_s "libdistorm64.dylib", libexec/"distorm64/libdistorm64.so"
      end
    end

    resource("pyew").stage do
      (libexec/"pyew").install Dir["*"]
      # Make sure that the launcher looks for pyew.py in the correct path (fixed
      # in pyew ab9ea236335e).
      inreplace libexec/"pyew/pyew", "\./pyew.py", "`dirname $0`/pyew.py"
    end

    python_path = "#{libexec}/lib/python2.7/site-packages:#{libexec}/pyew"
    ld_library_path = "#{libexec}/distorm64"
    (libexec/"bokken").install Dir["*"]
    (bin/"bokken").write <<~EOS
      #!/usr/bin/env bash
      env \
        PYTHONPATH=#{python_path}:${PYTHONPATH} \
        LD_LIBRARY_PATH=#{ld_library_path}:${LD_LIBRARY_PATH} \
        python #{libexec}/bokken/bokken.py "${@}"
    EOS
  end
end
