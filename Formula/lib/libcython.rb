class Libcython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/1a/1d/c79482ecb7217fc5840eceb724f7ebb4d3a70c5bf46309add0c0cd299891/Cython-3.0.3.tar.gz"
  sha256 "327309301b01f729f173a94511cb2280c87ba03c89ed428e88f913f778245030"
  license "Apache-2.0"

  livecheck do
    formula "cython"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e6d1e1a18f4943e0ce83c915f94e36f66e494a44cf254e0e51ee00c460ec01c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa838adb77dd96975221e451aff59a67dcbedc7fd5eac98851c73e39c4616cec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32fed4b2d07cd69578dd9946af09609a444683a01b7ecf2c175242c2b8d6f971"
    sha256 cellar: :any_skip_relocation, sonoma:         "6000ce35e704688c0df7cc860f3d28c84deb2aa29bc811d8f35d4526e1eeb9b0"
    sha256 cellar: :any_skip_relocation, ventura:        "9f010d7a807dd217e709749d09e8f27ecb7986f448a9e5dbf6175077d5212129"
    sha256 cellar: :any_skip_relocation, monterey:       "3832a58a4c5404789ced3136ff8beb6103909ca7b394b31bffb7414017fb7dff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a2dbc1999aa7978ab5d93138e6cb2fa06d136d6e3f63f913d35e62e026f410b"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python-setuptools" => [:build, :test]
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .sort_by(&:version)
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args(prefix: libexec), "."
    end
  end

  test do
    phrase = "You are using Homebrew"
    (testpath/"package_manager.pyx").write "print '#{phrase}'"
    (testpath/"setup.py").write <<~EOS
      from setuptools import setup
      from Cython.Build import cythonize

      setup(
        ext_modules = cythonize("package_manager.pyx")
      )
    EOS
    pythons.each do |python|
      with_env(PYTHONPATH: libexec/Language::Python.site_packages(python)) do
        system python, "setup.py", "build_ext", "--inplace"
        assert_match phrase, shell_output("#{python} -c 'import package_manager'")
      end
    end
  end
end
