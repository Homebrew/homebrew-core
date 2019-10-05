class Notifiers < Formula
  include Language::Python::Virtualenv

  desc "The easy way to send notifications"
  homepage "https://github.com/notifiers/notifiers"
  url "https://github.com/notifiers/notifiers/archive/1.2.0.tar.gz"
  sha256 "a06b6bde57f6252a2683eca7faefd491878796f143114389dde3d9490a4743c9"

  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "notifiers"
    venv.pip_install_and_link buildpath
  end

  test do
    assert_match "notifiers", shell_output("#{bin}/notifiers --help")
  end
end
