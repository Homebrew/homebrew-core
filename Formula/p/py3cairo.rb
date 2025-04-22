class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.28.0/pycairo-1.28.0.tar.gz"
  sha256 "26ec5c6126781eb167089a123919f87baa2740da2cca9098be8b3a6b91cc5fbc"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]

  bottle do
    sha256 cellar: :any, arm64_sequoia: "a3215f667bbecd5f84bd93fe29455894e9b051c088f69199224477652882f412"
    sha256 cellar: :any, arm64_sonoma:  "98f74d9de2ff0b9da6a0f3752725925cd946dc007620beca4b8670933fdcccb3"
    sha256 cellar: :any, arm64_ventura: "923bd6b36c154365fedc3d8cbc3f89f367749ea3c95852533db49d8d80907ee7"
    sha256 cellar: :any, sonoma:        "5f0839825ff8083f998042f7bbd37c368e75afa03d011d2c3d6df14978493459"
    sha256 cellar: :any, ventura:       "3ffe657d6f48d2ff7fcec7fb705de41c1c3eb4b64cdf539936fd4bd323f80233"
    sha256               arm64_linux:   "e7b6f3f1a4edcd963b16352778e82f8cd65f31c47b130ecdf5301ae8a77b3510"
    sha256               x86_64_linux:  "087eee4fa2c8b32998d1a57b09fd8b5256fe6b9deec5cef3c4593e715b10f988"
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
