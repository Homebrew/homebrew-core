class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/49/8a/6a4135469372da2e3d9f88f71c6d00d8a07ef65f121eeca0c7ae21697219/Cython-0.29.16.tar.gz"
  sha256 "232755284f942cbb3b43a06cd85974ef3c970a021aef19b5243c03ee2b08fa05"

  bottle do
    cellar :any_skip_relocation
    sha256 "eaeaf12607de3ef3cabd32bec18ebfa6b1dcf96610f72a82766671f452512db1" => :catalina
    sha256 "f72bcc4ac7cabf4dc14e643ec65b56f3bb9f56de8e8c6219bb802201a958fa31" => :mojave
    sha256 "99ada9be1fb65d70981e714bcf27134714f1968ff7fcc8751aaaf289624084b7" => :high_sierra
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
