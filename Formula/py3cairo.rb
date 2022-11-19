class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.22.0/pycairo-1.22.0.tar.gz"
  sha256 "b34517abdf619d4c7f0274f012b398d9b03bab7adc3efd2912bf36be3f911f3f"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b6ed8a697cc11c3fcb81b8599f468fef30feb367774e423b94c4a90f40298d99"
    sha256 cellar: :any,                 arm64_monterey: "835c501d1d5741824dd4a1e02cb0cc584bba31ad3de7dab749653ee626163417"
    sha256 cellar: :any,                 arm64_big_sur:  "4308fb117d43f27bd93ac2ae4f38091feff2272a474c560cfced167e8c1115cf"
    sha256 cellar: :any,                 ventura:        "84e5f8909f3f8e11e9bae1a9e54775c62abe8de803a0cf7eb7047f01a7518c1f"
    sha256 cellar: :any,                 monterey:       "feb8a9be1270be213fa1f6be9de3906017d49389713e0c5cd347350fcb7341ed"
    sha256 cellar: :any,                 big_sur:        "31a5442bd5a4c6fdf2a07abadf5ad49bf895ae6819b939be4d22687fc74aed40"
    sha256 cellar: :any,                 catalina:       "46d411dc3b30aa251d78ac0c0883be898e69eea4a090c0c25c02297a7c5a6950"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9369efb02ce11d15a79945b698b170fe830afacb1af390a52508e92f4a71c67"
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
      system python, *Language::Python.setup_install_args(prefix, python), "--install-data=#{prefix}"
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", "import cairo; print(cairo.version)"
    end
  end
end
