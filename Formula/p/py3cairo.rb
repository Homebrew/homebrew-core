class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.25.1/pycairo-1.25.1.tar.gz"
  sha256 "7e2be4fbc3b4536f16db7a11982cbf713e75069a4d73d44fe5a49b68423f5c0c"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "a6f2a66a286335946260a8fe5d7c7a77dd05f7afdf34d4174db040edab4e4a62"
    sha256 cellar: :any,                 arm64_ventura:  "2d857c94a1e5624a16da8c89bcb0469ca3fb33c8a90d49163c8f573cac40ca92"
    sha256 cellar: :any,                 arm64_monterey: "c83656feac5034c2e1d31c5cbb5ed917a48a927a1b8bf5c5fa3fcc4d3fa870d3"
    sha256 cellar: :any,                 sonoma:         "0a14974e5b425e7d354945b657699948c57321080b53af392e16e7b9eef9f511"
    sha256 cellar: :any,                 ventura:        "11fd7ef5da5e860628e5e47db532bff2052dc3e1566189887745f8ab11c26ff7"
    sha256 cellar: :any,                 monterey:       "30e0321b7afe520aedd0d4ead5f1e4048a53d1173dd15e8f631f90e2553b1835"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf5463859ee4031ee4d962dfb24b53629272252547b16050d17d54e29b768706"
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
