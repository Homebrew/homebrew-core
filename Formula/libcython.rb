class Libcython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/dc/f6/e8e302f9942cbebede88b1a0c33d0be3a738c3ac37abae87254d58ffc51c/Cython-0.29.33.tar.gz"
  sha256 "5040764c4a4d2ce964a395da24f0d1ae58144995dab92c6b96f44c3f4d72286a"
  license "Apache-2.0"

  livecheck do
    formula "cython"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5e3ab9ad1b8acc88814849923b2dc1b38b9c92360a25262c62ee2f3728a2a0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fa9e558d708f5147a117e8f2294ca7da536b1ef6bc663720f2c71ff807eb322"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19b5f477c479bb2e123a7bb6256f68332f9eefdb107656aa86cb1a80a7bb91a6"
    sha256 cellar: :any_skip_relocation, ventura:        "7db706db1aa710a2b75b9df45cd6706bbe895b462669b979f9728b53ef02a4d6"
    sha256 cellar: :any_skip_relocation, monterey:       "cfc83a5fae8efc1ba21d7002f82a1e286e94ec44d352aaf25c10b6b98f2a08bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e0689718cabfeff7f5fe3f57705b26ddd0982142774c689a072f52af7628ee7"
    sha256 cellar: :any_skip_relocation, catalina:       "aebb47718129ee4b0a543330fc9030b19011b5950ce17945a2ae315f131bf35b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d9973c0d66985d70ca141dc3cb981a1762b1093c3bc213b48499383793617c8"
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
