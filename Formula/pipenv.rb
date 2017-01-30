class Pipenv < Formula
  include Language::Python::Virtualenv
  desc "Sacred Marriage of Pipfile, Pip, & Virtualenv by @kennethreitz"
  homepage "https://github.com/kennethreitz/pipenv"
  url "https://github.com/kennethreitz/pipenv/archive/v3.2.10.tar.gz"
  sha256 "c213e610406746c0a9e0c4f0060a859b1a5417afdafc905877b24539db7d0349"

  depends_on :python if MacOS.version <= :lion

  def install
    venv = virtualenv_create(libexec)
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "pipenv"
    venv.pip_install_and_link buildpath
  end

  def caveats; <<-EOS.undent
      Proper casing should be used (e.g. Flask & Django).
      Hashes are generated in lockfiles but not (yet) used for installation.
      EOS
  end

  test do
    # Create a new project using Python 3
    system "#{bin}/pipenv", "--three"
    # Assert a Pipfile is created
    assert_match "1\n", shell_output("ls | grep -ci Pipfile")
    # Assert pipenv --help contains Commands
    assert_match "Commands", shell_output("#{bin}/pipenv --help")
    # Install requests
    system "#{bin}/pipenv", "install", "requests"
    # Assert requests is now installed
    assert_equal "1\n", shell_output("cat Pipfile | grep -ci requests")
    # Generate a Pipfile.lock file
    system "#{bin}/pipenv", "lock"
    # Assert Pipfile.lock is created
    assert_equal "1\n", shell_output("ls | grep -ci Pipfile.lock")
  end
end
