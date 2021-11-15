class Ns3 < Formula
  desc "Discrete-event network simulator"
  homepage "https://www.nsnam.org/"
  url "https://gitlab.com/nsnam/ns-3-dev/-/archive/ns-3.35/ns-3-dev-ns-3.35.tar.bz2"
  sha256 "946abd1be8eeeb2b0f72a67f9d5fa3b9839bb6973297d4601c017a6c3a50fc10"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any, arm64_monterey: "d343727db81354f68bbbc2c56550e0d1c5c0c946aa87c5b30e2b0d90bf491a8e"
    sha256 cellar: :any, arm64_big_sur:  "dd893b1a986fc45c114d577f7ad34e0ab88c3d87848096a18bcf54070f8f3627"
    sha256 cellar: :any, monterey:       "aa7730331907e010e3ca90966328b16f257abd57d2c4179b0b7e091bedb2bc4d"
    sha256 cellar: :any, big_sur:        "d41f6602cec43fb95b1e7633dc5661509224380f632aed0af5e02e02928c4d1d"
    sha256 cellar: :any, catalina:       "0cb4ec8959765ef9ad5057370209eb80ff8cc44054c8a780501e2849a2bf446f"
    sha256 cellar: :any, mojave:         "2159e2209f5605a2b3619e7c56429faa1969bab07e5b939964a2365b4a3685d2"
    sha256               x86_64_linux:   "190a0c1e80ce2be86042e35c5555a5a3fa035a135fecbe0425c770be6a60f96b"
  end

  depends_on "boost" => :build
  depends_on "python@3.9" => [:build, :test]

  uses_from_macos "libxml2"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "gcc"
  end

  # `gcc version 5.4.0 older than minimum supported version 7.0.0`
  fails_with gcc: "5"

  resource "pybindgen" do
    url "https://files.pythonhosted.org/packages/7a/c6/14a9359621000ee5b7d5620af679be23f72c0ed17887b15228327427f97d/PyBindGen-0.22.0.tar.gz"
    sha256 "5b4837d3138ac56863d93fe462f1dac39fb87bd50898e0da4c57fefd645437ac"
  end

  def install
    resource("pybindgen").stage buildpath/"pybindgen"

    system "./waf", "configure", "--prefix=#{prefix}",
                                 "--build-profile=release",
                                 "--disable-gtk",
                                 "--with-python=#{Formula["python@3.9"].opt_bin/"python3"}",
                                 "--with-pybindgen=#{buildpath}/pybindgen"
    system "./waf", "--jobs=#{ENV.make_jobs}"
    system "./waf", "install"

    pkgshare.install "examples/tutorial/first.cc", "examples/tutorial/first.py"
  end

  test do
    system ENV.cxx, pkgshare/"first.cc", "-I#{include}/ns#{version}", "-L#{lib}",
           "-lns#{version}-core", "-lns#{version}-network", "-lns#{version}-internet",
           "-lns#{version}-point-to-point", "-lns#{version}-applications",
           "-std=c++11", "-o", "test"
    system "./test"

    system Formula["python@3.9"].opt_bin/"python3", pkgshare/"first.py"
  end
end
