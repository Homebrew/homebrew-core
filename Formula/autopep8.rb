class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/cf/30/9efc988f92f41e2ba51211e3d317ee82260d563ae84dceb53f7021a1bdfe/autopep8-1.4.tar.gz"
  sha256 "655e3ee8b4545be6cfed18985f581ee9ecc74a232550ee46e9797b6fbf4f336d"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba4c3f07286967e8aa49c3df38ecd0e9c0260795f15159e0dd4e26693f4f8c92" => :mojave
    sha256 "f6e77ee274686216dbff20c6d50dc5b45e7788ea044b2cd03f560c2047066956" => :high_sierra
    sha256 "ec9a39c287040efb7a7266c98839eb4c02ac7ab3a99a44cd453121a3e4164288" => :sierra
    sha256 "b05bdbcfacaff3c7ac70958cc4056cb8504c5d7a97fb9765d6c8b234e857c6c6" => :el_capitan
  end

  depends_on "python@2"

  def install
    venv = virtualenv_create(libexec)
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    output = shell_output("echo \"x='homebrew'\" | #{bin}/autopep8 -")
    assert_equal "x = 'homebrew'", output.strip
  end
end
