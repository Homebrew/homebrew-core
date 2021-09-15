class Ns3 < Formula
  desc "Discrete-event network simulator"
  homepage "https://www.nsnam.org/"
  url "https://gitlab.com/nsnam/ns-3-dev/-/archive/ns-3.34/ns-3-dev-ns-3.34.tar.bz2"
  sha256 "a565d46a73ff7de68808535d93884f59a6ed7c9faa94de1248ed4f59fb6d5d3d"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "fd95713bcbe8aed7dbf18ad8331eb5008e9701795f625049ba8a9d19b5fe70e2"
    sha256 cellar: :any,                 big_sur:       "fc184536dfacb01cf9293483168462d7dcf3eaf568c34eef015af49c0346bd93"
    sha256 cellar: :any,                 catalina:      "c0dcd1239ea1897664ff798bc3c940828469121859cb8fa1aa8c6973974dc8f2"
    sha256 cellar: :any,                 mojave:        "998ffc954790eb1e4870117b8fd06c44875578f0520e23d19cc07867cdb5cc68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7d2d4dbeaf9749639f2015b6c19f36d00906dea01cf82a75475992752cd705c"
  end

  depends_on "boost" => :build
  depends_on "python@3.9" => [:build, :test]

  uses_from_macos "libxml2"
  uses_from_macos "sqlite"

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
