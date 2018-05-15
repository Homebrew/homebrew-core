class Bumpversion < Formula
  include Language::Python::Virtualenv

  desc "Version-bump your software with a single command"
  homepage "https://pypi.python.org/pypi/bumpversion"
  url "https://files.pythonhosted.org/packages/source/b/bumpversion/bumpversion-0.5.3.tar.gz"
  sha256 "6744c873dd7aafc24453d8b6a1a0d6d109faf63cd0cd19cb78fd46e74932c77e"

  depends_on "python@2"

  def install
    virtualenv_install_with_resources
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
