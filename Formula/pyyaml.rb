class Pyyaml < Formula
  desc "YAML framework for Python"
  homepage "https://pyyaml.org"
  url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
  sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "dcb5f25585264c27766cb706e535877243d7d6fd694daa297b854833907cf9a3"
    sha256 cellar: :any,                 arm64_big_sur:  "d825c57bca790ad92f58e03627e06371cd4f480071a0a5ca58141aca39d12d5a"
    sha256 cellar: :any,                 monterey:       "13436e5862d0648d93dcc9798775fbfcacf02b716dc92387f32ebfa837df5e2b"
    sha256 cellar: :any,                 big_sur:        "c9e711fc1796c9c7051935843f88ef57bf00accc628322238edb5fce923fa992"
    sha256 cellar: :any,                 catalina:       "7704923763aa0934d2e0e1c24fea1ed17fe11d3408babbb46bcec06c4799a7d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74ab35c0d3e1d77c1a6e7b9f5fa1810372b022a387760e06da0c018a8047a519"
  end

  depends_on "cython" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.8" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]
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
