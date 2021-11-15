class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.20.1/pycairo-1.20.1.tar.gz"
  sha256 "1ee72b035b21a475e1ed648e26541b04e5d7e753d75ca79de8c583b25785531b"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0231b0caa5204cff4c9665a1dcfd5b88dcccc7b88ccb3d06d9d0558dc98e774d"
    sha256 cellar: :any,                 arm64_big_sur:  "a4b8c6a9079f79e22396249ffbdf9f62f895fa8b7af83e038313f96f0dec2c2d"
    sha256 cellar: :any,                 monterey:       "0eecefe309601a2bf8652415ed2f92d8f6701612a408328d990be55d7693a0e1"
    sha256 cellar: :any,                 big_sur:        "ea6e1887539c142f3b24890521e9181fac8738d5fa2344c9e4c0734ea5b2b9a8"
    sha256 cellar: :any,                 catalina:       "a14c31fed107d6d3b3bf5ef8b067de63c020106be3e71f17285a0f3d028cec78"
    sha256 cellar: :any,                 mojave:         "1751fed8776a62fb799b5d025babe2692cb49647ff061e0527d8f010bab06a36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6b4152ae7579767ca0e49526a309686712628a0526098ab24af93603bc60edd"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "python@3.9"

  def install
    system Formula["python@3.9"].bin/"python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    system Formula["python@3.9"].bin/"python3", "-c", "import cairo; print(cairo.version)"
  end
end
