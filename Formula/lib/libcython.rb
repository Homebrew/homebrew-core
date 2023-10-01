class Libcython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/2f/81/c9fb4b69823f674e1e2acc484eac93a47a1e3a59d4d051c76259dadd6984/Cython-3.0.2.tar.gz"
  sha256 "9594818dca8bb22ae6580c5222da2bc5cc32334350bd2d294a00d8669bcc61b5"
  license "Apache-2.0"

  livecheck do
    formula "cython"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bbf0dc8a9a6d5bfcd81d90cc2a8a318d56186d91f1b5d9359351a6f7d01bcd51"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43ddd1a767fd47cc1ed0aea4b6879163ee027716a2408db7ca683ed8545c5f9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "649f03e776775dbd177fe9ef22ed5761fb9a60b2a41fdf17938350a1f9cf1df6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1c8b39554b3b9d18b72050e60403abf0389caad005d8f1742c7c42e6a3fdd05"
    sha256 cellar: :any_skip_relocation, sonoma:         "3cd4e664186e6f7a43608c9453590e394257d03495d20b489965f1580d915869"
    sha256 cellar: :any_skip_relocation, ventura:        "fbb9f9fb30bcf02de1eae322f6912fd58a98376f53b15399451469a39f363e16"
    sha256 cellar: :any_skip_relocation, monterey:       "5128468c7df3c7f359e49826936d1613530b7396d01d66acaa567563f19482f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "1760b68408acfe2cd5ec203d5d589581b37f9d2a262dd58635c9dfe71065dfb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "208dceb6157973fccd729141f88cbe2b118acebd1d83a502db21239b925f172f"
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
      system python, "-m", "pip", "install", *std_pip_args(prefix: libexec), "."
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
