class Py2cairo < Formula
  desc "Python 2 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.16.1/pycairo-1.16.1.tar.gz"
  sha256 "47a14a6a2f8dadb649229f099ac712a5f3d0a22e14877165a203d8a0de09ad63"

  bottle do
    cellar :any
    sha256 "6bc6d84becabc71f4989c02b833e9e6d915747fd9459632027466d97eafcd21f" => :high_sierra
    sha256 "17bfb8e6740745895802ec8f9c5fdbb6dde7fef19dfa3351e1e7be7975e86a16" => :sierra
    sha256 "a310ae96212e0401b490c2bbbd14786f2a7313d69455b7b813a6b554c1dc5b92" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "python" if MacOS.version <= :snow_leopard

  def install
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "python", "-c", "import cairo; print(cairo.version)"
  end
end
