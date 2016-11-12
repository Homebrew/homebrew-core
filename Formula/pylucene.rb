class Pylucene < Formula
  desc "Python extension for accessing Java Lucene"
  homepage "https://lucene.apache.org/pylucene/index.html"
  url "https://www.apache.org/dist/lucene/pylucene/pylucene-6.2.0-src.tar.gz"
  sha256 "ae60cbb41a96ad22bcd03cb3af488abf76c6312466ec2ac3dc965ca08cd2ea71"

  option "with-shared", "build jcc as a shared library"

  depends_on ant: :build
  depends_on java: "1.8+"
  depends_on :python

  def install
    ENV.prepend_create_path "PYTHONPATH", lib/"python2.7/site-packages"
    jcc = "JCC=python -m jcc --arch #{MacOS.preferred_arch}"
    opt = "INSTALL_OPT=--prefix #{prefix}"
    if build.with? "shared"
      jcc << " --shared"
      opoo "shared option requires python to be built with the same compiler: #{ENV.compiler}"
    else
      opt << " --use-distutils" # setuptools only required with shared
      ENV["NO_SHARED"] = "1"
    end

    cd "jcc" do
      system "python", "setup.py", "install", "--prefix=#{prefix}", "--single-version-externally-managed", "--record=install.txt"
    end
    ENV.deparallelize # the jars must be built serially
    system "make", "all", "install", opt, jcc, "ANT=ant -Divy_install_path=#{buildpath} -Divy.default.ivy.user.dir=#{buildpath} -lib #{buildpath}", "PYTHON=python", "NUM_FILES=8"
  end

  test do
    ENV.prepend_path "PYTHONPATH", HOMEBREW_PREFIX/"lib/python2.7/site-packages"
    system "python", "-c", "import lucene; assert lucene.initVM()"
  end
end
