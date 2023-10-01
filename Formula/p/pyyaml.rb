class Pyyaml < Formula
  desc "YAML framework for Python"
  homepage "https://pyyaml.org"
  url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
  sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7e21a7fd4f83a0eaa75722521742ddc8adc507d5909d49b22c377b9da8e37d59"
    sha256 cellar: :any,                 arm64_ventura:  "7e52df0812b2d3714c1d1504cbd07597aea578b1646e35ce2275fc484dd50957"
    sha256 cellar: :any,                 arm64_monterey: "c587e1c3c419d096678d0870087d1bb97f3b12f3bf264dde670c9d42c257bcd0"
    sha256 cellar: :any,                 arm64_big_sur:  "0834240857ef7d9f218257b66407fcf35ec9b213c4bb47cbf1760340991a9d70"
    sha256 cellar: :any,                 sonoma:         "e5b74ea593d6e85424a7869d44e4ce8bb923324e15bfda24da21327061038531"
    sha256 cellar: :any,                 ventura:        "3b77e8fcf1b747a263090daaa112390f47645bbfc16e56acac7de176ba874419"
    sha256 cellar: :any,                 monterey:       "e0b2451c2879083e566e96a20ca62ab210572789b02fe9f5c3157d818b7b91c5"
    sha256 cellar: :any,                 big_sur:        "28519daaaae05ab448355b3ee342b36c2493a3e90eb1d1d76ec5f49161259aca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d040e378298ea7ec94cfd92d3f41fb6dbeb4a07de2613a043db984a5624032c"
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
