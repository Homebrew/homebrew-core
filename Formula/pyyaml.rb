class Pyyaml < Formula
  desc "YAML framework for Python"
  homepage "https://pyyaml.org"
  url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
  sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9cdc9ef202bb642be23ec38c05c0ab6ce9b08d09ba5d954fb6440c946aa31e56"
    sha256 cellar: :any,                 arm64_monterey: "736cb99df3ba9c591dcc0087a6d1a2f1ade2f95a74366856098650212dfd5bb2"
    sha256 cellar: :any,                 arm64_big_sur:  "32d5689f7f30157f3b02369286001e1ad5b13a8b201981da4fd25cc8d15c16a3"
    sha256 cellar: :any,                 ventura:        "c7e2a65e145408bbbc3dd0aa680f76ed41339369278da1a0870299788f9d227b"
    sha256 cellar: :any,                 monterey:       "d71dd3186399ebca596677c148b23a0c90fdc09baeba4d617612b7dcf1788224"
    sha256 cellar: :any,                 big_sur:        "6002306dfd47f87b6fa817abb9b04bed296ce262cc0fe3ec516344c375ce7172"
    sha256 cellar: :any,                 catalina:       "41de8095ac8fe4230f3e3ad622b63d88def72ae332f52e823803c76de6541d5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f133abf84efeac83882a530cbedfd20181c1e6d0fbfe5a1ba380fd59211e72cd"
  end

  depends_on "cython" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "libyaml"

  def pythons
    deps.select { |dep| dep.name.start_with?("python") }
        .map(&:to_formula)
        .sort_by(&:version)
  end

  def install
    cythonize = Formula["cython"].bin/"cythonize"
    system cythonize, "yaml/_yaml.pyx"
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, *Language::Python.setup_install_args(prefix, python_exe)
    end
  end

  def caveats
    python_versions = pythons.map { |p| p.version.major_minor }
                             .map(&:to_s)
                             .join(", ")

    <<~EOS
      This formula provides the `yaml` module for Python #{python_versions}.
      If you need `yaml` for a different version of Python, use pip.
    EOS
  end

  test do
    pythons.each do |python|
      system python.opt_libexec/"bin/python", "-c", <<~EOS
        import yaml
        assert yaml.__with_libyaml__
        assert yaml.dump({"foo": "bar"}) == "foo: bar\\n"
      EOS
    end
  end
end
