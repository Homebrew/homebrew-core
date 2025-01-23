class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.27.0/pycairo-1.27.0.tar.gz"
  sha256 "5cb21e7a00a2afcafea7f14390235be33497a2cce53a98a19389492a60628430"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "83698156a1147d1961fa70a919496370251ab9bc57a18d813e932b13d180fc07"
    sha256 cellar: :any,                 arm64_sonoma:  "6c550cef7d08a8051c8e33cf2882802e1636331437e401309889d78a9671d9a8"
    sha256 cellar: :any,                 arm64_ventura: "8dfdae3387567f0970c43944f5867a7ebcf21529cf5ee7c87966166d899acd64"
    sha256 cellar: :any,                 sonoma:        "8e74bae3953954ec52fcd20290ee8c10fb24dac1ca8d7a5a58c54fe41935fe76"
    sha256 cellar: :any,                 ventura:       "2fcfb95901d05fc9c8726102a29eb4f280633e07fbda6bc684eb5268a7af2bfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "284d541089d7afbb8b2270c87e51d5f2bf904ff821a4e2c503bf8692f6bad00d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
  depends_on "cairo"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def site_packages(python)
    prefix/Language::Python.site_packages(python)
  end

  def install
    pythons.each do |python|
      python_version = Language::Python.major_minor_version(python)
      builddir = "build#{python_version}"
      system "meson", "setup", builddir, "-Dpython=#{python}",
                                         "-Dpython.platlibdir=#{site_packages(python)}",
                                         "-Dpython.purelibdir=#{site_packages(python)}",
                                         *std_meson_args
      system "meson", "compile", "-C", builddir
      system "meson", "install", "-C", builddir
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", "import cairo; print(cairo.version)"
    end
  end
end
