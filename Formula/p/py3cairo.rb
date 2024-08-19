class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.26.1/pycairo-1.26.1.tar.gz"
  sha256 "a11b999ce55b798dbf13516ab038e0ce8b6ec299b208d7c4e767a6f7e68e8430"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9872316be45ac21743a63d6e9c4165f125f76241f81f450925384ad6c9f56a28"
    sha256 cellar: :any,                 arm64_ventura:  "bdf1a2dc71ee1238a9cad324b6c8aec5b9f958ed90e68b74dafa036da8c4c923"
    sha256 cellar: :any,                 arm64_monterey: "6acb67f31aabc144bbc3d1499a057143a2603ab5774a4a4d9f1aa1becbe7918d"
    sha256 cellar: :any,                 sonoma:         "5a92deccbd6de58c824fc620c02b67d8eddbecb61a77ae124b6f885c31305cd4"
    sha256 cellar: :any,                 ventura:        "0e4efb0ff72b94e5eb521389ac80aea56b62605d9bc64c77836d3fa8f9af1bf8"
    sha256 cellar: :any,                 monterey:       "c57f09bacd597190089da0e01d3dd1748ba4da701ccebad7efce36ba02b7a79a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59ec00f546dd2b571cfebabc3700ce02e2e585a94235f398f372d95d51f3577c"
  end

  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
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
