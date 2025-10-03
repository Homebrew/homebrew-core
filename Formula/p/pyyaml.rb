class Pyyaml < Formula
  desc "YAML framework for Python"
  homepage "https://pyyaml.org"
  url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
  sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "87a238bf1e44a97f54755f0e95ba11860884b186678d3ce163db3034b7b2d7cc"
    sha256 cellar: :any,                 arm64_sonoma:   "b538bcab64b4ab3f6351c219cff42e2d163201efcaa272e4ee7e58783ffb3ce6"
    sha256 cellar: :any,                 arm64_ventura:  "eb0cb94ff9dc6ac7926c1ee71ccdc42dc844ad3ab949b9105456cf131c25027d"
    sha256 cellar: :any,                 arm64_monterey: "d87fbc05ae74fc9f2c882c5047f6f9587bd782165776a2132ab26fd3fa11dab7"
    sha256 cellar: :any,                 sonoma:         "1ac9a131912b8c3d48e751d7d39c17c1c8d3d84d81353ab82d66fa5fb6d31772"
    sha256 cellar: :any,                 ventura:        "dc66728628c4bb38e894111a480f8ac86369ac73d87b148874878f8c565bb0c5"
    sha256 cellar: :any,                 monterey:       "e01aba3d0afab94578fc5f708ee01adf0549572005aa82c2c292679663c23995"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d53f5c35de430f055c83fdbb1e857b3423cbea9c66523f929cb525876ef55fae"
  end

  disable! date: "2024-10-06", because: "does not meet homebrew/core's requirements for Python library formulae"

  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "libyaml"

  def pythons
    deps.select { |dep| dep.name.start_with?("python@") }
        .map(&:to_formula)
        .sort_by(&:version)
  end

  def install
    pythons.each do |python|
      python3 = python.opt_libexec/"bin/python"
      system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end
  end

  def caveats
    python_versions = pythons.map { |p| p.version.major_minor }
                             .map(&:to_s)
                             .join(", ")

    <<~EOS
      This formula provides the `yaml` module for Python #{python_versions}.
      If you need `yaml` for a different version of Python, use pip.

      Additional details on upcoming formula removal are available at:
      * https://github.com/Homebrew/homebrew-core/issues/157500
      * https://docs.brew.sh/Python-for-Formula-Authors#libraries
      * https://docs.brew.sh/Homebrew-and-Python#pep-668-python312-and-virtual-environments
    EOS
  end

  test do
    pythons.each do |python|
      system python.opt_libexec/"bin/python", "-c", <<~PYTHON
        import yaml
        assert yaml.__with_libyaml__
        assert yaml.dump({"foo": "bar"}) == "foo: bar\\n"
      PYTHON
    end
  end
end
