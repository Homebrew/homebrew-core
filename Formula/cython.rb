class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/79/36/69246177114d0b6cb7bd4f9aef177b434c0f4a767e05201b373e8c8d7092/Cython-0.29.19.tar.gz"
  sha256 "97f98a7dc0d58ea833dc1f8f8b3ce07adf4c0f030d1886c5399a2135ed415258"

  bottle do
    cellar :any_skip_relocation
    sha256 "9115d505ec961b4fb34e4fb930670217dfa311512be4d520562f1ccf64e4498c" => :catalina
    sha256 "2cfa7471fd175324a4ccbf841a0606e5c57f0d7aeeda7155c2bbcaf70aa60f71" => :mojave
    sha256 "258a0c474ce53d288adafa9ea0fd88f6ab5f071d47a4c2977c67751fb1ec84d3" => :high_sierra
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python@3.8"

  def install
    xy = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system Formula["python@3.8"].opt_bin/"python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    xy = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    phrase = "You are using Homebrew"
    (testpath/"package_manager.pyx").write "print '#{phrase}'"
    (testpath/"setup.py").write <<~EOS
      from distutils.core import setup
      from Cython.Build import cythonize

      setup(
        ext_modules = cythonize("package_manager.pyx")
      )
    EOS
    system Formula["python@3.8"].opt_bin/"python3", "setup.py", "build_ext", "--inplace"
    assert_match phrase, shell_output("#{Formula["python@3.8"].opt_bin}/python3 -c 'import package_manager'")
  end
end
