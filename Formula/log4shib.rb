class Log4shib < Formula
  desc "Forked version of log4cpp for the Shibboleth project"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/log4shib"
  url "https://shibboleth.net/downloads/log4shib/2.0.0/log4shib-2.0.0.tar.gz"
  sha256 "d066e2f208bdf3ce28e279307ce7e23ed9c5226f6afde288cd429a0a46792222"
  license "LGPL-2.1"

  livecheck do
    url "https://shibboleth.net/downloads/log4shib/latest/"
    regex(/href=.*?log4shib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "07b780239ff655d1c4b5de7bb4cbf5a9daed61f0e691a10c8ad7880a658ce23f"
    sha256 cellar: :any,                 big_sur:       "b739ef276c38d293771f5d42185637de5944974cd42d677c88d08e2e2627731e"
    sha256 cellar: :any,                 catalina:      "8bba779ac511127d2893aa7f90e08fea86e49d54a002363edac8396143b53fd2"
    sha256 cellar: :any,                 mojave:        "db9aa2c4c1f5f562177d7ab8f772d3634af17ad321866da25da81986c2806941"
    sha256 cellar: :any,                 high_sierra:   "6a84a5b1db0fa9fef6e23f906543bde2496e5400f498c8de6b64cab2b191eeda"
    sha256 cellar: :any,                 sierra:        "79197ed691693493ffc4b44dd5450b60c9c6cc97919302ae058c9e9af5cd10f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "136a804ca90390b69fd57818855efbeefe5d1c5a44fcd523dab57fa54194ca47"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
    (pkgshare/"test").install %w[tests/log4shib.init tests/testConfig.cpp tests/testConfig.log4shib.properties]
  end

  test do
    cp_r (pkgshare/"test").children, testpath
    system ENV.cxx, "testConfig.cpp", "-I#{include}", "-L#{lib}", "-llog4shib", "-o", "test", "-pthread"
    system "./test"
  end
end
