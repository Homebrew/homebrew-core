class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/dd/35/85dc65305bd86ad78aefdb6247bd786ec85e3cb7d86357c5c7ba2e6ae099/autopep8-1.4.2.tar.gz"
  sha256 "1b8d42ebba751a91090d3adb5c06840b1151d71ed43e1c7a9ed6911bfe8ebe6c"

  bottle do
    cellar :any_skip_relocation
    sha256 "b374259188e69e0b91d1f0576d9bd4b75ff638f3f7241e691b6ee69a18651b80" => :mojave
    sha256 "99bc0ceee1c917403eccfd5a22f3925d5b8838d54c84f62525d05719bd973957" => :high_sierra
    sha256 "39b08655edbfa69c7ef47a472bfd013fbccf6eb7ee03f5bccc1fb7b3e751d19f" => :sierra
  end

  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")
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
