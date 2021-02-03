class Maggot < Formula
  include Language::Python::Virtualenv

  desc "GUI frontend for Msc-generator"
  homepage "https://sourceforge.net/p/msc-generator"
  url "https://downloads.sourceforge.net/project/msc-generator/maggot/v1.x/maggot-1.3.3-py3-none-any.whl"
  sha256 "98fda1ec7db109d6845ebe795c75d54a9fcba76ced1ea9ccf44b85b0c85a9065"
  license "GPL-3.0-or-later"

  depends_on "gtk+3"
  depends_on "msc-generator"
  depends_on "pygobject3"
  depends_on "python@3.9"

  def install
    venv = virtualenv_create libexec, "python3"
    # (pip|virtualenv)_install do not install .whl implicitly so we tell it to
    venv.pip_install_and_link "#{buildpath}/maggot-#{version}-py3-none-any.whl"
  end

  test do
    # Try to open a file to have the machinery start up.
    # It will exit with an error as the file is non-existent but we don't care
    # as long as we see the stdout greeting.
    assert_match "Maggot v#{version.major_minor}, welcome!", shell_output("maggot /no-such-file 2>&1", 1)
  end
end
