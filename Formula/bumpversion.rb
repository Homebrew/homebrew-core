class Bumpversion < Formula
  include Language::Python::Virtualenv

  desc "Increase version numbers with SemVer terms"
  homepage "https://pypi.python.org/pypi/bumpversion"
  url "https://github.com/peritus/bumpversion/archive/v0.5.3.tar.gz"
  sha256 "97ac6efca7544853309b68efe92f113ab6bddb77ecbaefa5702a6183a30bcb33"

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_includes shell_output("script -q /dev/null #{bin}/bumpversion --help"), "bumpversion: v#{version}"
    version_file = testpath/"VERSION"
    version_file.write "0.0.0"
    system bin/"bumpversion", "--current-version", "0.0.0", "minor", version_file
    assert_match "0.1.0", version_file.read
    system bin/"bumpversion", "--current-version", "0.1.0", "patch", version_file
    assert_match "0.1.1", version_file.read
    system bin/"bumpversion", "--current-version", "0.1.1", "major", version_file
    assert_match "1.0.0", version_file.read
  end
end
