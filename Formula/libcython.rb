class Libcython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/0a/70/1500f05bddb16d795b29fac42954b3c8764c82367b8326c10f038471ae7f/Cython-0.29.34.tar.gz"
  sha256 "1909688f5d7b521a60c396d20bba9e47a1b2d2784bfb085401e1e1e7d29a29a8"
  license "Apache-2.0"

  livecheck do
    formula "cython"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14264abad17f530db5025d1e33d2d6535e7cf3f7118176a34b1962b7e72441e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "412ecf90656519b3db8679e7d0bbcb1deed6f4b7d66cee0b51b3783069dbaf4d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4fb58167d0f7d148bb157fd43b80633033b89931b9cd52736e36397e8f277153"
    sha256 cellar: :any_skip_relocation, ventura:        "5057ba4a850af163840150193ccaafa794921fc07396c60290ca69f9d68aceea"
    sha256 cellar: :any_skip_relocation, monterey:       "d311243d395d5c40dffb0ae6242e1754c00eafe5c88043e6d049f184bae39732"
    sha256 cellar: :any_skip_relocation, big_sur:        "285b494142f39260d8a7b1fef12da3ac68db8a42587a6017ed933b1a7346d635"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83be1ef8070f6ba4fa150facac9d1d8dcccf780114395ab4b35d0d6b055045b5"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .sort_by(&:version)
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, *Language::Python.setup_install_args(libexec, python)
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
      with_env(PYTHONPATH: libexec/Language::Python.site_packages(python)) do
        system python, "setup.py", "build_ext", "--inplace"
        assert_match phrase, shell_output("#{python} -c 'import package_manager'")
      end
    end
  end
end
