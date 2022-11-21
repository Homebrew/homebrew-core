class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/4c/76/1e41fbb365ad20b6efab2e61b0f4751518444c953b390f9b2d36cf97eea0/Cython-0.29.32.tar.gz"
  sha256 "8733cf4758b79304f2a4e39ebfac5e92341bce47bcceb26c1254398b2f8c1af7"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9f4dc2920d4e31725778411b6922e21c347cdd75148428c23e15de4db901d1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d9702d7c3cac259bf540260539d96e5cb03d6f2d8fd71b35dfcb55538f4d76d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f92aef3f7e177e949def01ae805c9ba8b37c62857dae46f3f16ec2ed85035382"
    sha256 cellar: :any_skip_relocation, ventura:        "11531c28dd566645b887d02a2afb80de4885ad657386a44093021d0a48ab6b62"
    sha256 cellar: :any_skip_relocation, monterey:       "9ef112e38bc7dcd82751a0f322d8a8c88639c3452788ac1a9f1772f558834041"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd075ab129ce7f981560d2b56459d4741c674293a9d9d0f7398dde8b9496192d"
    sha256 cellar: :any_skip_relocation, catalina:       "79688ff4f1a8eb6e2c29e5e8eaafd262e19d4437b424f46258de84feab637936"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d2a91820415ec12b81e747aa5b64875a3ea67bbf2eefe2c651641827e16720e"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python@3.11"

  def install
    python = "python3.11"
    ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages(python)
    system python, *Language::Python.setup_install_args(libexec, python)

    bin.install (libexec/"bin").children
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    python = Formula["python@3.11"].opt_bin/"python3.11"
    ENV.prepend_path "PYTHONPATH", libexec/Language::Python.site_packages(python)

    phrase = "You are using Homebrew"
    (testpath/"package_manager.pyx").write "print '#{phrase}'"
    (testpath/"setup.py").write <<~EOS
      from distutils.core import setup
      from Cython.Build import cythonize

      setup(
        ext_modules = cythonize("package_manager.pyx")
      )
    EOS
    system python, "setup.py", "build_ext", "--inplace"
    assert_match phrase, shell_output("#{python} -c 'import package_manager'")
  end
end
