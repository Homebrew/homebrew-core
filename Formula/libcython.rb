class Libcython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/d4/ad/7ce0cccd68824ac9623daf4e973c587aa7e2d23418cd028f8860c80651f5/Cython-0.29.30.tar.gz"
  sha256 "2235b62da8fe6fa8b99422c8e583f2fb95e143867d337b5c75e4b9a1a865f9e3"
  license "Apache-2.0"

  livecheck do
    formula "cython"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3547b61daa04975cdeca65c2f5dcd76335619ecc99be15506159b97725a83a55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54a6665ed4813a918fdc5308c2b3c5e4fd1acdcf4630fc8af80703b6902fe40f"
    sha256 cellar: :any_skip_relocation, monterey:       "d975afcf2be568ecae4f7c0f369ea450655eccd405d0a1d8362ddfd153813d82"
    sha256 cellar: :any_skip_relocation, big_sur:        "987be03173753d1d80ed8b7023aafbdcf1e0227e80e89df1a013d7d260801216"
    sha256 cellar: :any_skip_relocation, catalina:       "03e55003b8669211d159fe77b9c30e55f16a96021af2bda04b3cc04069c6d5d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cbf5d66d16756ddb822eb308677762833559955bbb79d0b83900fe86e113474"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/python@\d\.\d+/) }
        .map(&:opt_bin)
        .map { |bin| bin/"python3" }
  end

  def install
    pythons.each do |python|
      ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages(python)
      system python, *Language::Python.setup_install_args(libexec),
             "--install-lib=#{libexec/Language::Python.site_packages(python)}"
    end
  end

  test do
    phrase = "You are using Homebrew"
    (testpath/"package_manager.pyx").write "print '#{phrase}'"
    (testpath/"setup.py").write <<~EOS
      from distutils.core import setup
      from Cython.Build import cythonize

      setup(
        ext_modules = cythonize("package_manager.pyx")
      )
    EOS
    pythons.each do |python|
      ENV.prepend_path "PYTHONPATH", libexec/Language::Python.site_packages(python)
      system python, "setup.py", "build_ext", "--inplace"
      assert_match phrase, shell_output("#{python} -c 'import package_manager'")
    end
  end
end
