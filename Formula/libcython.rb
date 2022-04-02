class Libcython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/cb/da/54a5d7a7d9afc90036d21f4b58229058270cc14b4c81a86d9b2c77fd072e/Cython-0.29.28.tar.gz"
  sha256 "d6fac2342802c30e51426828fe084ff4deb1b3387367cf98976bb2e64b6f8e45"
  license "Apache-2.0"

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
