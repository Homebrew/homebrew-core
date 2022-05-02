class Libcython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/cb/da/54a5d7a7d9afc90036d21f4b58229058270cc14b4c81a86d9b2c77fd072e/Cython-0.29.28.tar.gz"
  sha256 "d6fac2342802c30e51426828fe084ff4deb1b3387367cf98976bb2e64b6f8e45"
  license "Apache-2.0"

  livecheck do
    formula "cython"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15b21f47a97041f16f9d0143e6b011920491267b1dd71fdb1683ef7a8ab6722c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e8c9c60bc707275e42d135c69f72517b5f0d601a12d89699b53238c18a4bc65"
    sha256 cellar: :any_skip_relocation, monterey:       "2d07b7ccea8e99c93173a67c461712da05bce53352ce1db55325fd4d931f65a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "adf28d7d10dd4d0d345622baf43fe7b4b520cf88ebdd8f127948c51f4f0cc725"
    sha256 cellar: :any_skip_relocation, catalina:       "7b69ff6248181a2a94baea2e61165015dd6a3d92da338613048a4be4b6bfe6ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05be5253f5203ba63fc74cbba3a5b56c9056c52f72762aca6fab9069e5d2fe45"
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
