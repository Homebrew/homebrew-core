class Py2cairo < Formula
  desc "Python 2 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.18.1/pycairo-1.18.1.tar.gz"
  sha256 "70172e58b6bad7572a3518c26729b074acdde15e6fee6cbab6d3528ad552b786"

  bottle do
    cellar :any
    sha256 "db4127cd316e919e5c49be339e6ea0ddb20ae3eacf21969b4e48bd60b9c6622f" => :catalina
    sha256 "03ad3e2f9143464e5168ce2f225e0b064b070737301216a67658457c0ca4f456" => :mojave
    sha256 "a50b0c485a57c92b994de627796d6daf7c98b6aa5c35d89b67ee5bef5e26e458" => :high_sierra
    sha256 "f095cacdd07d60a81a01ca1468df6cd544f2684050d051eaecd7808adbe3928e" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "python@2"

  def install
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "python", "-c", "import cairo; print(cairo.version)"
  end
end
