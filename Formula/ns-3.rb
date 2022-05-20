class Ns3 < Formula
  desc "Discrete-event network simulator"
  homepage "https://www.nsnam.org/"
  url "https://gitlab.com/nsnam/ns-3-dev/-/archive/ns-3.35/ns-3-dev-ns-3.35.tar.bz2"
  sha256 "946abd1be8eeeb2b0f72a67f9d5fa3b9839bb6973297d4601c017a6c3a50fc10"
  license "GPL-2.0-only"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_monterey: "2e8c6e69fc3e3866afb6f182bd26c71b80e3a58d4880cd8f6054ef7c147a124e"
    sha256 cellar: :any, arm64_big_sur:  "dd4c3113659b5387a39effcb95b5edaeb18400a2049c40b482375af252b83b16"
    sha256 cellar: :any, monterey:       "b2b171ff93422374391a69a414561ce8ceec76938a62c1d5c388b3b456661546"
    sha256 cellar: :any, big_sur:        "3fb6baaf7d10b550ec756602d98efb6ec00d05203b6e2b48ad8e59102b42f8ba"
    sha256 cellar: :any, catalina:       "7475b685b7494e1db8a4c10d66e594b02821aa5cc3618e238997de9016efe737"
    sha256               x86_64_linux:   "c09b477ad12e7718faecaef392d6d0a4fac02985c5f3cd2eaae15f2c87cb3f43"
  end

  depends_on "boost" => :build
  depends_on "python@3.10" => [:build, :test]

  uses_from_macos "libxml2"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "gcc"
  end

  # `gcc version 5.4.0 older than minimum supported version 7.0.0`
  fails_with gcc: "5"

  resource "pybindgen" do
    url "https://files.pythonhosted.org/packages/e0/8e/de441f26282eb869ac987c9a291af7e3773d93ffdb8e4add664b392ea439/PyBindGen-0.22.1.tar.gz"
    sha256 "8c7f22391a49a84518f5a2ad06e3a5b1e839d10e34da7631519c8a28fcba3764"
  end

  # Fix ../src/lte/model/fdmt-ff-mac-scheduler.cc:1044:16: error:
  # variable 'bytesTxed' set but not used [-Werror,-Wunused-but-set-variable]
  # TODO: remove in the next release.
  patch do
    url "https://gitlab.com/nsnam/ns-3-dev/-/commit/dbd49741fcd5938edec17eddcde251b5dee25d05.diff"
    sha256 "28e92297cfe058cfb587527dc3cfdb8ac66b51aba672be29539b6544591e2f1e"
  end

  def install
    resource("pybindgen").stage buildpath/"pybindgen"

    system "./waf", "configure", "--prefix=#{prefix}",
                                 "--build-profile=release",
                                 "--disable-gtk",
                                 "--with-python=#{which("python3")}",
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

    system Formula["python@3.10"].opt_bin/"python3", pkgshare/"first.py"
  end
end
