class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/c1/f2/d1207fd0dfe5cb4dbb06a035eb127653821510d896ce952b5c66ca3dafa4/Cython-0.29.2.tar.gz"
  sha256 "2ac187ff998a95abb7fae452b5178f91e1a713698c9ced89836c94e6b1d3f41e"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ccd16ca82d623d7efff95ddf2c37ef66ec2f0535acc54d8a9d3cba394fead52" => :mojave
    sha256 "2e1cbec07446df0a447b197955e4ec58172e75bece4736e5f1e1383347db5a79" => :high_sierra
    sha256 "2504bb8f8fdd713352fea8acc3d606e7a66147a81ecb1e280953841df3a5993e" => :sierra
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    xy = Language::Python.major_minor_version "python3"
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
    system "python3", "setup.py", "build_ext", "--inplace"
    assert_match phrase, shell_output("python3 -c 'import package_manager'")
  end
end
