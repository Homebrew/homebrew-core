class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.22.0/pycairo-1.22.0.tar.gz"
  sha256 "b34517abdf619d4c7f0274f012b398d9b03bab7adc3efd2912bf36be3f911f3f"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "93befda735b45aa8c04d1bc288b88b8c2b41d9f63f8236bc8e6184c580789e69"
    sha256 cellar: :any,                 arm64_monterey: "e80415048672894adc9c906c9838760956813acb342ff523a21943edcae47688"
    sha256 cellar: :any,                 arm64_big_sur:  "614fa1e30f7428f49531d7708c01565ce583a63ae1224a4e4f98361f5133b236"
    sha256 cellar: :any,                 monterey:       "dad977428d3e8d0c02738180ca86e99dcd690b188c6ec2cef4cfbafbc8220cbd"
    sha256 cellar: :any,                 big_sur:        "dc68f9a97b73f946b71fe5818b4077e9339054233eeefe7756f4bb8b2c633f00"
    sha256 cellar: :any,                 catalina:       "77936c68a96077618720722fa8810c8c4b74c8330f7f4d8fe92f7ae91aa201e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfcc86df6633f5dc9327bd964e1acd9f8697f4cd21bae0f3aa9c39d8d3cdf0fa"
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
