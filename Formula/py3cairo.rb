class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.20.0/pycairo-1.20.0.tar.gz"
  sha256 "5695a10cb7f9ae0d01f665b56602a845b0a8cb17e2123bfece10c2e58552468c"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]

  bottle do
    cellar :any
    sha256 "8d7fb028f118ee48b41f37256354838d8ac1b5c5ddd3f4c80acb6a70d27c0b3f" => :catalina
    sha256 "74c0fbb1f660169302566b04d22e0a6ed308c1a9ee7fd077a00a30108ab8469b" => :mojave
    sha256 "8972b7ae6715c28e042915ab5437ce3c79f272ef54b4cbfaaa69b69449a958c7" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "python@3.8"

  def install
    system Formula["python@3.8"].bin/"python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    system Formula["python@3.8"].bin/"python3", "-c", "import cairo; print(cairo.version)"
  end
end
