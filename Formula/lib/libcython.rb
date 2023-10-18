class Libcython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/3f/aa/1a5c72615e0ba4dc30cc36de7e8a9a2eca2158922b0677654fced0d3476c/Cython-3.0.4.tar.gz"
  sha256 "2e379b491ee985d31e5faaf050f79f4a8f59f482835906efe4477b33b4fbe9ff"
  license "Apache-2.0"

  livecheck do
    formula "cython"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7689b50549c2cf9ed0c49b2fffe890ca53ba5c8aa30d5b07f7102965cd7144d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e843ae39e5ce2d170f23ed15b39908a04a4299923f440368a6e5e3b2316e278f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59d3dcbb76bba68a182ff5b42b221bf2abe4b7eca819c55329f7b9d48f8019f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "1679faae8b30626d72656327a4cc9983b81c61d4440836d66ce0ea29253a8661"
    sha256 cellar: :any_skip_relocation, ventura:        "14724e4e34f1f08b20d33428a7a054652ce6c8eca4b7cebdbaa04f4dc57ca6ab"
    sha256 cellar: :any_skip_relocation, monterey:       "408e348ac5bd7c9ca47711734acf86150e05cf9f0e4d31ab18e5df7db8868234"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efda2bc19f5aecde73612c48235669e075fd56539f6500ec145cf1e81fc29abf"
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
