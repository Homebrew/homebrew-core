class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.29.0/pycairo-1.29.0.tar.gz"
  sha256 "f3f7fde97325cae80224c09f12564ef58d0d0f655da0e3b040f5807bd5bd3142"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5262a6f83c776ac9a3325488dd92216a9865f271d6de30de4b465ec771ee8968"
    sha256 cellar: :any, arm64_sequoia: "7cc2d0de913b912639584bfe94d5658cfb82cb7c898b8269ad69c09747a28709"
    sha256 cellar: :any, arm64_sonoma:  "f614c1cf5e35eaf7726331446258f9d7662182843715149bb316e0cc3f440816"
    sha256 cellar: :any, sonoma:        "f915d3efc320997a2e05c5948b3eea84f5c7640cc58542fb4d86fe936416a5db"
    sha256               arm64_linux:   "81629e2f6185689b774840bc69f19b56571f1fa8644545aa645c31fe2e3c61bb"
    sha256               x86_64_linux:  "5692a6792c7aaf933469acc5ff1c51a6b21e11d8f98439f3baf9e525bd2e18b5"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]
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
