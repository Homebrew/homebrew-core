class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.29.2/pycairo-1.29.2.tar.gz"
  sha256 "3e69fff74fe64f5ba2dfa31f67c6bdf26413342574047437d2ac520d35e9a489"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f655280ba2f9f284b43ab39f3c6a2400d2844a7b1ce0a4c7386e3fb67e03c666"
    sha256 cellar: :any, arm64_tahoe:       "b514f1c006f63711ab230bf3833a5a29d18221777250ec51b6fe2269eb42e874"
    sha256 cellar: :any, arm64_sequoia:     "3bede70c829760bf17e9fa3d66969d3789c85e0927f23b97f07ecc3a2cdc8063"
    sha256 cellar: :any, arm64_linux:       "a0542258cdfa629cffa2c343751d851280de15d1fae37b948e64404a3f337de0"
    sha256 cellar: :any, x86_64_linux:      "cdb5fc354213e7e8e3738a403908677a44f087a6a91e85f623ff0616e51726c3"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "python@3.15" => [:build, :test]
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
