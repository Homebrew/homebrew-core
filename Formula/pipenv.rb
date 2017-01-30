class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Sacred Marriage of Pipfile, Pip, & Virtualenv"
  homepage "https://github.com/kennethreitz/pipenv"
  url "https://github.com/kennethreitz/pipenv/archive/v3.2.10.tar.gz"
  sha256 "c213e610406746c0a9e0c4f0060a859b1a5417afdafc905877b24539db7d0349"

  depends_on :python

  def install
    venv = virtualenv_create(libexec)
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    # system libexec/"bin/pip", "install", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "pipenv"
    venv.pip_install_and_link buildpath
  end

  test do
    system "#{bin}/pipenv", "--three"
    File.exist?("Pipfile")
    system "#{bin}/pipenv", "install", "requests"
    assert_match "requests", shell_output("cat Pipfile")
    system "#{bin}/pipenv", "lock"
    File.exist?("Pipfile.lock")
  end
end
