class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.26.0/pycairo-1.26.0.tar.gz"
  sha256 "2dddd0a874fbddb21e14acd9b955881ee1dc6e63b9c549a192d613a907f9cbeb"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "38d16fa2096fb056dfbf77cbcaa283cfb640e089c069335898d41d68eb829d86"
    sha256 cellar: :any,                 arm64_ventura:  "4b2cbfaf883d0ff081c427c594684f6451084662b37313db7142592d29375f33"
    sha256 cellar: :any,                 arm64_monterey: "0e371f6adb6355305fb80e9e45964d15b0c5d0fb2af71ee648edf8487f7d9816"
    sha256 cellar: :any,                 sonoma:         "5c4c36eb048b8abf0875249a087e8464341c6ee8201baf42b3566e0aea6e8f3e"
    sha256 cellar: :any,                 ventura:        "cc8d57e4c6337816342b4f3f452decf1a3199dd94419b1da1576a5b863bdda2f"
    sha256 cellar: :any,                 monterey:       "48856d83d62ccac512e9f9f64a8e5d38b436705cca9bc57245bc658067ca6699"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17fff13682d9d912842c200261b0e1a58af1031e4fe5e1009d30f1adf1f99d37"
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
