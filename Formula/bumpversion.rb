class Bumpversion < Formula
  include Language::Python::Virtualenv

  desc "Version-bump your software with a single command"
  homepage "https://pypi.python.org/pypi/bumpversion"
  url "https://pypi.io/packages/source/b/bumpversion/bumpversion-0.5.0.tar.gz"
  sha256 "030832b9b46848e1c1ac6678dba8242a021e35e908b65565800c9650291117dc"

  depends_on "python@2"

  def install
    venv = virtualenv_create(libexec)
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    (testpath/"VERSION").write "1.2.0"
    system "#{bin}/bumpversion", "patch",
           "--current-version", "1.2.0",
           "--new-version", "1.2.1",
           "VERSION"
    assert_equal "1.2.1", (testpath/"VERSION").read
  end
end
