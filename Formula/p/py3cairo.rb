class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.24.0/pycairo-1.24.0.tar.gz"
  sha256 "1444d52f1bb4cc79a4a0c0fe2ccec4bd78ff885ab01ebe1c0f637d8392bcafb6"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "08560134178fc9e8e80bbe3e952f4b97f77de24762fc460c8cec6bea84046693"
    sha256 cellar: :any,                 arm64_ventura:  "e4d800015c97ddaeee41ff6acd81b546ac527390d0c858d5eb7e1b01dcd4b413"
    sha256 cellar: :any,                 arm64_monterey: "ea420032b73fcffad9f60d2bb14762ed2e6be7f16b63df73d91edc16d63047f9"
    sha256 cellar: :any,                 arm64_big_sur:  "e656545fc71d55a771ab33e90082ae82ca40a8ec45400c2f3f55b16a4cfd53b8"
    sha256 cellar: :any,                 sonoma:         "b0fd4eabd7b21d25570972b71e6e806357d22bdeabbd93c8d894761580e007ba"
    sha256 cellar: :any,                 ventura:        "6fcbf02ec9eb9c0983e1c05a40622495806741379cbe6cae1f492bd8cdc94d42"
    sha256 cellar: :any,                 monterey:       "bf9963d0209d0d7f590b14468be8cc98fd78031b1a77f7a1dab63732d7a28f05"
    sha256 cellar: :any,                 big_sur:        "f3fd07081a416d80f5451520d9c953d11ae3c08f2ea1cc9fcec0a4c26d5549d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "313433ef1c481f3758c31a1af49b9a329522e29394325a9967f354b4442afaa0"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "cairo"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", "import cairo; print(cairo.version)"
    end
  end
end
