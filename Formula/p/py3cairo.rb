class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.29.1/pycairo-1.29.1.tar.gz"
  sha256 "4fbd26b4af24c9787d84cf5448e34eb8dca064b732479aaecd03109520eebd5f"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bb4b42d1a1057e84108f383e0d72955f7cf5975fb6897910cc181dccc8167180"
    sha256 cellar: :any, arm64_sequoia: "a5992328b8e630888b26f3c533e4c754f8ca33097ab46c7dce1fcb3501731d8f"
    sha256 cellar: :any, arm64_sonoma:  "837aee600bfaf857f7131c7e1deadcccccf596182451f08a0fcc543a563aa83a"
    sha256 cellar: :any, sonoma:        "a6752508c41efaee1a23746104268ca56be9566933fab10e66b18d7871ea29ba"
    sha256               arm64_linux:   "a526357a59d85808fdfae0eb7b89d0bddaa9d07b994f38a695fceb122b82ed57"
    sha256               x86_64_linux:  "2329cc38ce7645d0be9da6ce8c153039b6b960099baaa73617f93ce0b2043a61"
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
