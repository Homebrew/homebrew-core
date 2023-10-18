class Pyyaml < Formula
  desc "YAML framework for Python"
  homepage "https://pyyaml.org"
  url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
  sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "561544b18dbe365ea4daed0d6e1f04f84f8db7b9311a7b2b4f23448730a370d0"
    sha256 cellar: :any,                 arm64_ventura:  "9ce2dadb085a4e6fe2fa4f5f107384559f7fd7f4d006a71a83bab79021be70c2"
    sha256 cellar: :any,                 arm64_monterey: "0b9169a71a1d719043a8e435fe5676f043d168f67e6e7ca38d12dc7cc6595054"
    sha256 cellar: :any,                 sonoma:         "5a8994e5ad9d4cf01275fd65cb6df8f2357c58ee87299c2dad847e95b7075b12"
    sha256 cellar: :any,                 ventura:        "7649b84c4833bab198324c0fa390d391895081735a2ddce27afa0b1d7d33237b"
    sha256 cellar: :any,                 monterey:       "32e3ad242518e37b4b772c137c7700f26585d1e6d1a885479dd9f10f675ea9c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "053ab09b8e289c2168344ee24de7e08318f96d0404279c916420deb01bef35a9"
  end

  depends_on "cython" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "libyaml"

  def pythons
    deps.select { |dep| dep.name.start_with?("python@") }
        .map(&:to_formula)
        .sort_by(&:version)
  end

  def install
    cythonize = Formula["cython"].bin/"cythonize"
    system cythonize, "yaml/_yaml.pyx"
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
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
