class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/7e/48/89a4aa420f63ff35bd0081433e483a991234558fefb1ac4e4f1b62b059b9/cython-3.2.6.tar.gz"
  sha256 "6509472a245ccdf5fd11637a4744a1edfd38debb1a48332a8f3fe4b07db725bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b21f5988375e40fb60b47bfd5b16080c5d7b603c8f5b70d7dc3cb1a2ffc0d210"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56fd69585fd08ebc82b23ab4e0a989648a958ef32d6129e39f4ec90fbb8f9afa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a664c74c938b700d028175802cf10895e09d87a9cd494ef75d2b9f4b6a145b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "3beb62825fe4383890eb4308a5e95f47b2b5b3730954746a73384a8ea7419409"
    sha256 cellar: :any,                 arm64_linux:   "0814f61fda084fa34ac02a8098cde83eee75c7b3ed60608132e0d974b81a1a8f"
    sha256 cellar: :any,                 x86_64_linux:  "b18595509b233d76dd0fe9a4a8d2c6304d99d0e4cce632cc1a6e4ae435e8e898"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python-setuptools" => [:build, :test]
  depends_on "python@3.14"

  def python3
    "python3.14"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)
    system python3, "-m", "pip", "install", *std_pip_args(prefix: libexec), "."

    bin.install (libexec/"bin").children
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    ENV.prepend_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)

    phrase = "You are using Homebrew"
    (testpath/"package_manager.pyx").write "print '#{phrase}'"
    (testpath/"setup.py").write <<~PYTHON
      from distutils.core import setup
      from Cython.Build import cythonize

      setup(
        ext_modules = cythonize("package_manager.pyx")
      )
    PYTHON
    system python3, "setup.py", "build_ext", "--inplace"
    assert_match phrase, shell_output("#{python3} -c 'import package_manager'")
  end
end
