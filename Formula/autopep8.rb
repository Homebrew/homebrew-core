class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/dd/35/85dc65305bd86ad78aefdb6247bd786ec85e3cb7d86357c5c7ba2e6ae099/autopep8-1.4.2.tar.gz"
  sha256 "1b8d42ebba751a91090d3adb5c06840b1151d71ed43e1c7a9ed6911bfe8ebe6c"

  bottle do
    cellar :any_skip_relocation
    sha256 "6fdbe3cb67cd8b820be23a0847485f1ff6d4a11b0b7066ff5d1a0e964e897256" => :mojave
    sha256 "eb3b850d9fe853742faf06509e36b4d77075ce37497acb15f9d980f06d5a2bb2" => :high_sierra
    sha256 "d6bffbbfe5a6808ac2ec1ee873ab8832773e68d1299ca06e6b1b7879ae6a959d" => :sierra
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
