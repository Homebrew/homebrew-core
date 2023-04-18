class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.23.0/pycairo-1.23.0.tar.gz"
  sha256 "9b61ac818723adc04367301317eb2e814a83522f07bbd1f409af0dada463c44c"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c3fb62311b4289c1ae34eb9a798f827009fdb0c6edad049cd6d6f58bca3a921d"
    sha256 cellar: :any,                 arm64_monterey: "2e3c30b7fcdfbabee0e1d086e5ae44396a90bfd49cbb45e5ad268a23fb2329b5"
    sha256 cellar: :any,                 arm64_big_sur:  "fd3bd19e4c9d0a3ab792099835e3d8ff624b3958b0064b906df3d6cd01effebc"
    sha256 cellar: :any,                 ventura:        "6696dd1a0827c972c9eec4164e44804e264538e595e5719d12afc8f6d76ffdcb"
    sha256 cellar: :any,                 monterey:       "5435a3f3a2642dc80e08293507b3370a22dee7db9abb18180a18d513e1be7676"
    sha256 cellar: :any,                 big_sur:        "7e2754f9e40733b62707a0fa4167d438728b1241981df62a5f57ee42575de15a"
    sha256 cellar: :any,                 catalina:       "8ca6b71d03d4af1933749b800785062dd01ae3422dae51a4b46c967f2a430291"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b30bdcc53e02f9c4ee0a03b8abbee005eaf788ebd3b0d65b2c6e1506e281995b"
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
